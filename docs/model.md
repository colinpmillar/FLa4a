# The FLa4a model and how it is fitted

This document gives the equations of the statistical catch-at-age model in
FLa4a and of each step used to fit it. Section 4 maps every equation to the R
function that implements it.

Contents

1. [Notation](#1-notation)
2. [Model definition](#2-model-definition)
3. [Fitting](#3-fitting)
4. [After fitting](#4-after-fitting)
5. [Where the equations are implemented](#5-where-the-equations-are-implemented)

## 1. Notation

| Symbol | Meaning |
|---|---|
| $a = 1,\dots,A$ | age index (first age $a_0$, oldest age $A$, possibly a plus group) |
| $y = 1,\dots,Y$ | year index |
| $f = 0, 1, \dots, S$ | fleet: $f = 0$ is the catch, $f = s \ge 1$ the survey indices |
| $N_{ay}, F_{ay}, M_{ay}$ | numbers, fishing mortality and natural mortality at age and year |
| $Z_{ay} = F_{ay} + M_{ay}$ | total mortality |
| $C_{ay}$ | catch in numbers |
| $I_{say}$, $I_{sy}$ | index at age, or biomass index, of survey $s$ |
| $q_{say}$ | catchability of survey $s$ |
| $\sigma_{fay}$ | observation standard deviation (log scale) |
| $w_{ay}$, $m_{ay}$ | stock weight and maturity |
| $\phi^F_{ay}$, $\phi^M_{ay}$ | fractions of $F$ and $M$ before spawning |
| $t_s$ | timing of survey $s$ as a fraction of the year |
| $\mathbf X$ | design matrix of a submodel |
| $\boldsymbol\beta$ | unpenalised coefficients |
| $\mathbf u$ | coefficients of penalised smoothers |
| $\boldsymbol\theta$ | variance parameters (coefficients of the variance submodel) |
| $\lambda_j$ | smoothing parameters, estimated as $\rho_j = \log\lambda_j$ |

Vectors over age and year cells are stacked with age varying fastest, the
layout of an `FLQuant`.

## 2. Model definition

### 2.1 Data and centring

The observations are the catch at age $C^{\text{obs}}_{ay}$ and the survey
indices $I^{\text{obs}}_{say}$ (or $I^{\text{obs}}_{sy}$ for a biomass index).
Missing values are excluded; the others must be positive. Each fleet's log observations are
centred by their mean,

$$
c_f = \frac{1}{n_f}\sum_{i \in f} \log O_i ,
\qquad
y_i = \log O_i - c_f ,
$$

where $O_i$ is observation $i$ and $n_f$ the number of observations of fleet
$f$. The model works with numbers on the catch's centred scale,
$\tilde N_{ay} = N_{ay} e^{-c_0}$; catchability absorbs the difference in
centring between a survey and the catch (Section 4.1).

Optional observation weights come from the variances $v_i$ supplied with the
data (`catch.n` as an `FLQuantDistr`, or `index.var`), rescaled to mean one
over all observations:

$$
\omega_i = \left(\frac{v_i}{\bar v}\right)^{-1}, \qquad \bar v = \frac{1}{n}\sum_i v_i .
$$

Without variances all $\omega_i = 1$.

### 2.2 Submodels

Each quantity below is a linear predictor on the log scale, defined by a
formula in `age`, `year` and any covariates:

$$
\begin{aligned}
\log F_{ay} &= \big(\mathbf X_F \boldsymbol\beta_F + \mathbf Z_F \mathbf u_F\big)_{ay}
  && \texttt{fmodel} \\
\log q_{say} &= \big(\mathbf X_{q,s} \boldsymbol\beta_{q,s} + \mathbf Z_{q,s} \mathbf u_{q,s}\big)_{ay}
  && \texttt{qmodel[[s]]} \\
\log \sigma_{fay} &= \big(\mathbf X_{\sigma,f} \boldsymbol\theta_f + \mathbf Z_{\sigma,f} \mathbf u_{\sigma,f}\big)_{ay}
  && \texttt{vmodel[[f]]} \\
\log \tilde N_{a1} &= \big(\mathbf X_{N_1} \boldsymbol\beta_{N_1} + \mathbf Z_{N_1} \mathbf u_{N_1}\big)_{a}, \quad a > 1
  && \texttt{n1model} \\
\log \tilde R_{y} = \log \tilde N_{1y} &= \big(\mathbf X_R \boldsymbol\beta_R + \mathbf Z_R \mathbf u_R\big)_{y}
  && \texttt{srmodel}
\end{aligned}
$$

$\mathbf X$ holds the unpenalised columns and $\mathbf Z$ the columns of
penalised smoothers (Section 2.7); without penalties $\mathbf Z$ is empty. For
an age-structured survey the rows of $\mathbf X_{q,s}$ and $\mathbf X_{\sigma,s}$
are evaluated at the age clamped to the survey's age range,
$a^\star = \min(\max(a, a_s^{\min}), a_s^{\max})$, so a smoother in age is not
extrapolated beyond the ages the survey observes.

**Design matrices.** A formula is turned into a design matrix with mgcv:
parametric terms use sum-to-zero contrasts, and smoothers (`s()`, `te()`,
`ti()`, `t2()`) use mgcv's bases with its identifiability constraints absorbed.
The basis is built on the unique rows of the data, so duplicated rows (from the
age clamping) do not affect knot placement. Unpenalised columns that make the
matrix rank deficient are removed: with the pivoted QR decomposition
$\mathbf X \mathbf P = \mathbf Q \mathbf R$, a column is dropped when
$|R_{jj}| < 10^{-4}$. The fitted basis is kept, so the design matrix can be
evaluated at new covariate values with the same knots and columns (Section 4.2).

### 2.3 Population dynamics

Recruitment and numbers in the first year come from their submodels. For
$y > 1$ and $1 < a < A$,

$$
\log \tilde N_{ay} = \log \tilde N_{a-1,y-1} - Z_{a-1,y-1} ,
$$

and the oldest age, when it is a plus group, accumulates survivors from the two
oldest ages,

$$
\log \tilde N_{Ay} = \log\!\Big(
  e^{\log \tilde N_{A-1,y-1} - Z_{A-1,y-1}} + e^{\log \tilde N_{A,y-1} - Z_{A,y-1}}
\Big),
$$

computed as a numerically stable log-sum-exp. Without a plus group only the
first term is used.

### 2.4 Predicted observations

Catch at age follows the Baranov equation:

$$
\log \tilde C_{ay} = \log F_{ay} - \log Z_{ay} + \log\!\big(1 - e^{-Z_{ay}}\big) + \log \tilde N_{ay} .
$$

A survey index at age is proportional to the numbers present at the survey's
time of year,

$$
\log \tilde I_{say} = \log q_{say} + \log \tilde N_{ay} - t_s Z_{ay} ,
$$

and a biomass index sums over the survey's ages $\mathcal A_s$, weighted by
stock weight:

$$
\log \tilde I_{sy} = \log \sum_{a \in \mathcal A_s} q_{say}\, w_{ay}\, \tilde N_{ay}\, e^{-t_s Z_{ay}} .
$$

The survey time is the midpoint of the survey period,
$t_s = (\texttt{startf} + \texttt{endf}) / 2$. Write $\mu_i$ for the predicted
log observation $i$ ($\log \tilde C_{ay}$, $\log \tilde I_{say}$ or
$\log \tilde I_{sy}$).

### 2.5 Observation likelihood

Log observations are normal around their predictions,
$y_i \sim \mathcal N(\mu_i, \sigma_i^2)$, with $\sigma_i$ the variance submodel
at the observation's fleet, year and age (the youngest age for a biomass
index). Each observation's log density is weighted:

$$
\ell_f = \sum_{i \in f} \omega_i \log \phi(y_i;\, \mu_i, \sigma_i)
= -\sum_{i \in f} \omega_i \left[ \log \sigma_i + \tfrac12 \log 2\pi + \frac{(y_i - \mu_i)^2}{2 \sigma_i^2} \right].
$$

There is one likelihood component per fleet.

### 2.6 Stock-recruitment relationship

When `srmodel` names a stock-recruitment relationship, recruitment is a free
parameter per year, $\log \tilde R_y = \beta_{R,y}$, and a lognormal penalty
ties it to a curve of spawning stock biomass. SSB (on the centred scale) is

$$
\tilde S_y = \sum_a \tilde N_{ay}\, e^{-\phi^F_{ay} F_{ay} - \phi^M_{ay} M_{ay}}\, m_{ay}\, w_{ay} ,
$$

and recruits at age $a_0$ in year $y$ come from $\tilde S_{y - a_0}$. With
$\alpha_y$ and $\beta_y$ the (log-scale) curve parameters, from their own
formulas (`a` and `b`, by default constant), the predicted log recruitment is

| Model | $\log \hat R_y$ |
|---|---|
| `bevholt` | $\alpha_y + \log S - \log(e^{\beta_y} + S)$ |
| `ricker` | $\alpha_y + \log S - e^{\beta_y} S$ |
| `hockey` | $\alpha_y + \log\!\Big(S + \sqrt{e^{2\beta_y} + \gamma^2/4} - \sqrt{(S - e^{\beta_y})^2 + \gamma^2/4}\Big)$, $\gamma = 0.1$ |
| `geomean` | $\alpha_y$ |
| `bevholtSV` | $\log(6 h v S) - \log\!\big(\text{SPR}_0\,[(h+1) v + (5h - 1) S]\big)$, $h = 0.2 + 0.8\,\text{logit}^{-1}(\alpha_y)$, $v = e^{\beta_y}$ |

with $S = \tilde S_{y - a_0}$. The penalty is

$$
\ell_{\text{SR}} = \sum_{y} \log \phi\big(\log \tilde R_y;\, \log \hat R_y,\, \sigma_R\big),
\qquad \sigma_R^2 = \log(\text{CV}^2 + 1),
$$

over years $y > a_0$ (years $y > 1$ for `geomean`). The CV is either given
by the user, or, with `CV = NA`, estimated: $\sigma_R$ becomes a parameter
(estimated as $\log \sigma_R$) and the yearly recruitments become random
effects with the distribution
$\log \tilde R_y \sim \mathcal N(\log \hat R_y, \sigma_R^2)$, integrated out
of the likelihood (Section 3.4). The reported CV is
$\sqrt{e^{\sigma_R^2} - 1}$.

### 2.7 Penalised smoothers

With `penalise`, the coefficients $\mathbf u_b$ of each penalised smoother $b$
have a Gaussian prior whose precision is its penalty matrices $\mathbf S_{bj}$
(from mgcv) weighted by smoothing parameters:

$$
\mathbf Q_b(\boldsymbol\lambda) = \sum_j \lambda_{bj} \mathbf S_{bj},
\qquad
\log p(\mathbf u_b \mid \boldsymbol\lambda)
= \tfrac12 \log |\mathbf Q_b|_+ - \tfrac12\, \mathbf u_b^\top \mathbf Q_b \mathbf u_b - \tfrac{r_b}{2} \log 2\pi ,
$$

where $r_b = \operatorname{rank}(\mathbf Q_b)$ and $|\cdot|_+$ is the
pseudo-determinant. The prior is flat on the null space of $\mathbf Q_b$, the
directions the penalty leaves free (for example a linear trend under a
second-order penalty). A single `s()` has one penalty; a tensor product
(`te()`, `ti()`, `t2()`) has one per margin, e.g. one smoothing parameter
across ages and one across years.

The pseudo-determinant is computed with a sparse GMRF density. Let
$\mathbf N_b$ be an orthonormal basis of the null space of $\sum_j \mathbf S_{bj}$
(eigenvectors with eigenvalue below $10^{-8}$ of the largest). Then
$|\mathbf Q_b|_+ = |\mathbf Q_b + \mathbf N_b \mathbf N_b^\top|$, and

$$
\log p(\mathbf u_b \mid \boldsymbol\lambda)
= \log \phi_{\text{GMRF}}\big(\mathbf u_b;\, \mathbf 0,\, \mathbf Q_b + \mathbf N_b \mathbf N_b^\top\big)
+ \tfrac12 \big\lVert \mathbf N_b^\top \mathbf u_b \big\rVert^2
+ \tfrac{n_b - r_b}{2} \log 2\pi ,
$$

with $n_b$ the number of coefficients and $\phi_{\text{GMRF}}$ the normal
density with sparse precision (RTMB's `dgmrf()`).

### 2.8 The objective

The negative log-likelihood, as a function of all coefficients
$\boldsymbol\psi = (\boldsymbol\beta, \mathbf u, \boldsymbol\theta)$ given the
smoothing parameters, is

$$
\mathcal L(\boldsymbol\psi; \boldsymbol\lambda) =
-\sum_{f} \ell_f \;-\; \ell_{\text{SR}} \;-\; \sum_b \log p(\mathbf u_b \mid \boldsymbol\lambda) .
$$

The terms are reported separately in `fitSumm()` as `nlogl:<fleet>`,
`nlogl:srr` and `nlogl:smooth`. The data negative log-likelihood reported as
`nlogl` is $-\sum_f \ell_f - \ell_{\text{SR}}$, without the smoother priors;
when recruitment is a random effect, $\ell_{\text{SR}}$ is its distribution
and is left out of `nlogl` too.

## 3. Fitting

Each iteration of the stock and indices is fitted independently. The
objective and its derivatives come from RTMB, which records the R code above as
an automatic-differentiation tape.

### 3.1 Maximum likelihood, unpenalised

Without penalised smoothers, all coefficients are estimated by maximum
likelihood,

$$
\hat{\boldsymbol\psi} = \arg\min_{\boldsymbol\psi} \mathcal L(\boldsymbol\psi),
$$

with `nlminb` (a quasi-Newton method) from $\boldsymbol\psi = \mathbf 0$,
followed by up to three Newton steps,

$$
\boldsymbol\psi \leftarrow \boldsymbol\psi - \mathbf H^{-1} \nabla \mathcal L ,
\qquad \mathbf H = \nabla^2 \mathcal L ,
$$

each kept only if it reduces the largest absolute gradient. The covariance
matrix of the estimates (`fit = "assessment"`) is the inverse Hessian,
$\widehat{\operatorname{Var}}(\hat{\boldsymbol\psi}) = \mathbf H^{-1}$,
computed through its Cholesky factor; a Hessian that is not positive definite
flags the fit as not converged.

### 3.2 The Hessian through the linear predictors

The likelihood depends on the coefficients only through the stacked linear
predictors $\boldsymbol\eta$ (all cells of $\log F$, $\log q$, $\log \sigma$,
$\log \tilde N_{\cdot 1}$, $\log \tilde R$ and the SR parameters), which are
linear in the coefficients:

$$
\boldsymbol\eta = \mathbf A \boldsymbol\psi ,
\qquad
\mathcal L(\boldsymbol\psi; \boldsymbol\lambda)
= D(\mathbf A \boldsymbol\psi) - \sum_b \log p(\mathbf u_b \mid \boldsymbol\lambda),
$$

where $\mathbf A$ is a sparse block matrix of the design matrices and $D$ the
data (and SR) part. Hence

$$
\nabla^2_{\boldsymbol\psi} \mathcal L
= \mathbf A^\top \big[\nabla^2_{\boldsymbol\eta} D\big] \mathbf A
+ \operatorname{blockdiag}_b\big(\mathbf Q_b(\boldsymbol\lambda)\big).
$$

$\nabla^2_{\boldsymbol\eta} D$ is sparse: an observation involves only the
cells along its cohort, plus its own catchability and variance cells. It is
evaluated from a sparse Hessian tape recorded once per fit, which is several
times faster than the dense Hessian in the coefficients. Penalised fits use
this form throughout.

### 3.3 Penalised smoothers

The smoothing parameters maximise the Laplace approximation to the marginal
likelihood in which the smoother coefficients are integrated out. For fixed
$\boldsymbol\rho = \log \boldsymbol\lambda$, let
$\hat{\boldsymbol\psi}(\boldsymbol\rho)$ minimise
$\mathcal L(\boldsymbol\psi; \boldsymbol\lambda)$ (the penalised likelihood fit),
and $\mathbf H_{uu}$ be the block of the Hessian for the smoother coefficients.
Then

$$
\mathcal L_{\text{LA}}(\boldsymbol\rho)
= \mathcal L\big(\hat{\boldsymbol\psi}(\boldsymbol\rho); \boldsymbol\lambda\big)
+ \tfrac12 \log \lvert \mathbf H_{uu} \rvert - \tfrac{q}{2} \log 2\pi ,
$$

with $q$ the number of smoother coefficients. It is reported as
`nlogl:marginal`. Two methods estimate $\boldsymbol\rho$.

#### Extended Fellner-Schall updates (`sp.method = "efs"`, default)

The extended Fellner-Schall method (Wood and Fasiolo, 2017) alternates a
penalised fit with a closed-form update of each smoothing parameter.

1. **Penalised fit.** Given $\boldsymbol\rho$, minimise
   $\mathcal L(\boldsymbol\psi; \boldsymbol\lambda)$ over $\boldsymbol\psi$: by
   `nlminb` from zero at the first iteration, then by Newton steps from the
   previous solution,
   $\boldsymbol\psi \leftarrow \boldsymbol\psi - t\, \mathbf H^{-1} \nabla \mathcal L$,
   halving $t$ until the objective decreases, until
   $\max |\nabla \mathcal L| < 10^{-6}$ (falling back to `nlminb` when a Newton
   step makes no progress).
2. **Update.** With $\mathbf V = \mathbf H_{uu}^{-1}$ and $\mathbf Q_b^-$ the
   pseudo-inverse of $\mathbf Q_b$, each smoothing parameter of block $b$ is
   updated as

   $$
   \lambda_{bj} \leftarrow \lambda_{bj}\,
   \frac{\operatorname{tr}\!\big(\mathbf Q_b^- \mathbf S_{bj}\big) - \operatorname{tr}\!\big(\mathbf V_{bb} \mathbf S_{bj}\big)}
        {\hat{\mathbf u}_b^\top \mathbf S_{bj} \hat{\mathbf u}_b} .
   $$

   On the log scale the step is limited to $\pm 5$, the numerator is floored at
   a small positive value, and $\rho_{bj}$ is kept within $[-20, 25]$. The fixed
   point of this update maximises $\mathcal L_{\text{LA}}$ when the dependence of
   $\mathbf H_{uu}$ on $\hat{\boldsymbol\psi}$ is ignored; no third derivatives
   are needed.
3. **Step control.** The update does not always improve the marginal
   likelihood, so the step $\Delta\boldsymbol\rho$ is halved (up to six times)
   until $\mathcal L_{\text{LA}}(\boldsymbol\rho + \Delta\boldsymbol\rho) \le \mathcal L_{\text{LA}}(\boldsymbol\rho)$.
4. **Convergence.** Stop when $\max |\Delta\boldsymbol\rho| < 10^{-3}$, when the
   marginal likelihood improves by less than $10^{-5}$ (a smoothing parameter
   drifting along a flat direction, typically towards no penalty), or when no
   halved step improves it.

#### Laplace approximation (`sp.method = "laplace"`)

Starting from the Fellner-Schall estimates, $\mathcal L_{\text{LA}}$ is
maximised directly with RTMB's Laplace approximation, treating $\mathbf u$ as
random effects: the inner problem finds
$\hat{\mathbf u}(\boldsymbol\beta, \boldsymbol\theta, \boldsymbol\rho)$ by
Newton's method and the outer problem minimises the Laplace approximation over
$(\boldsymbol\beta, \boldsymbol\theta, \boldsymbol\rho)$ with `nlminb`, using
gradients that include the dependence of $\mathbf H_{uu}$ on the coefficients
(third derivatives). This is exact to the Laplace approximation but slower for
large tensor-product smoothers.

#### Effective degrees of freedom and covariance

The effective degrees of freedom of smoother $b$ are

$$
\text{edf}_b = n_b - \operatorname{tr}\!\big(\mathbf V_{bb}\, \mathbf Q_b(\hat{\boldsymbol\lambda})\big),
$$

between the null-space dimension and $n_b$. The covariance of all coefficients
is the inverse of the penalised Hessian at the estimates, the Bayesian
posterior covariance given $\hat{\boldsymbol\lambda}$.

### 3.4 Recruitment as a random effect

With an estimated SR CV, the likelihood cannot be maximised jointly over the
recruitments and $\sigma_R$: recruitment could follow the curve exactly and
drive $\sigma_R$ to zero. The recruitment coefficients $\boldsymbol\beta_R$
are instead integrated out:

$$
\mathcal L_{\text{LA}}(\boldsymbol\beta_{-R}, \boldsymbol\theta, \log\sigma_R)
= \mathcal L(\hat{\boldsymbol\beta}_R, \boldsymbol\beta_{-R}, \boldsymbol\theta)
+ \tfrac12 \log \lvert \mathbf H_{RR} \rvert - \tfrac{n_R}{2} \log 2\pi ,
$$

where $\hat{\boldsymbol\beta}_R$ minimises $\mathcal L$ given the other
parameters and $\mathbf H_{RR}$ is its Hessian. The fit has two stages:

1. fit with $\sigma_R$ held at its starting value (CV = 0.5): by maximum
   likelihood (Section 3.1) or, with penalised smoothers, by Fellner-Schall
   (Section 3.3);
2. from there, maximise $\mathcal L_{\text{LA}}$ with RTMB's Laplace
   approximation, the recruitments (and any smoother coefficients, whose
   smoothing parameters are then estimated as in `sp.method = "laplace"`)
   being random effects.

$\mathcal L_{\text{LA}}$ is reported as `nlogl:marginal`. The covariance of
the coefficients is the inverse Hessian of $\mathcal L$ at the estimates
(conditional on $\hat\sigma_R$). The recruitments' effective degrees of
freedom are

$$
\text{edf}_R = n_R - \operatorname{tr}\!\big(\mathbf H_{RR}^{-1} \mathbf P\big),
\qquad \mathbf P = \mathbf X_{R}^\top \mathbf X_{R} / \hat\sigma_R^2 ,
$$

where $\mathbf X_R$ holds the rows of the recruitment design matrix for the
years with an SR prior; $\mathbf P$ ignores the dependence of the curve on
SSB. With informative data $\text{edf}_R$ is close to $n_R$ and recruitment is
barely shrunk towards the curve; with noisy data the shrinkage improves the
recruitment estimates. Part of the recruitment variability is then attributed
to observation error, so $\hat\sigma_R$ tends to be low (by about 25% in
simulations with catch and survey sds of 0.1-0.5).

### 3.5 REML

Maximum likelihood estimates the observation variances as if the other
coefficients were known, and so underestimates them. With `method = "REML"`
the variance parameters and smoothing parameters instead maximise the
restricted likelihood, in which all other coefficients
$\boldsymbol\gamma = (\boldsymbol\beta, \mathbf u)$ are integrated out with flat
priors on the unpenalised ones (and the recruitment distribution as the prior
of random recruitments, whose $\sigma_R$ is then an outer parameter too):

$$
\mathcal L_{\text{REML}}(\boldsymbol\theta, \boldsymbol\rho)
= -\log \int e^{-\mathcal L(\boldsymbol\gamma, \boldsymbol\theta; \boldsymbol\lambda)}\, d\boldsymbol\gamma
\;\approx\;
\mathcal L(\hat{\boldsymbol\gamma}, \boldsymbol\theta; \boldsymbol\lambda)
+ \tfrac12 \log \lvert \mathbf H_{\gamma\gamma} \rvert - \tfrac{p_\gamma}{2} \log 2\pi ,
$$

where $\hat{\boldsymbol\gamma}$ minimises $\mathcal L$ given
$(\boldsymbol\theta, \boldsymbol\lambda)$, $\mathbf H_{\gamma\gamma}$ is its
Hessian and $p_\gamma$ the number of integrated coefficients. It is maximised
with RTMB's Laplace approximation ($\boldsymbol\gamma$ as random effects,
$(\boldsymbol\theta, \boldsymbol\rho)$ as the outer parameters), starting from
the ML (or Fellner-Schall) fit, and reported as `nlogl:marginal`.

At the REML estimates $\hat{\boldsymbol\theta}$ is not at a joint-likelihood
optimum, so the joint Hessian need not be positive definite. The covariance is
therefore built in two blocks:

$$
\widehat{\operatorname{Var}}(\hat{\boldsymbol\gamma}) = \mathbf H_{\gamma\gamma}^{-1}
\;\;\text{(conditional on } \hat{\boldsymbol\theta}, \hat{\boldsymbol\lambda}\text{)},
\qquad
\widehat{\operatorname{Var}}(\hat{\boldsymbol\theta}) = \Big[\big(\nabla^2_{(\boldsymbol\theta, \boldsymbol\rho)} \mathcal L_{\text{REML}}\big)^{-1}\Big]_{\theta\theta},
$$

with zero covariance between them. The second Hessian is found numerically from
the AD gradients of $\mathcal L_{\text{REML}}$. REML likelihoods of models with
different submodels for $F$, catchability, initial numbers or recruitment are
not comparable; models are compared by AIC under ML.

### 3.6 Convergence

A fit is flagged as not converged (`fitSumm()["convergence", ]` = 1) when:

* `nlminb` does not report success. For the Laplace-based optimisations
  (`sp.method = "laplace"`, random recruitment, REML), whose objective carries a little numerical
  noise from the inner optimisation, "false convergence" is accepted when the
  largest absolute outer gradient is below 0.01;
* the smoothing parameters do not converge, or the final penalised fit has
  $\max |\nabla \mathcal L| \ge 10^{-3}$;
* the Hessian used for the covariance is not positive definite, or the
  smoother coefficients' Hessian is singular.

### 3.7 Fit summaries

For unpenalised fits `nopar` is the number of coefficients $p$. For penalised
fits, and fits with random recruitment, it counts the unpenalised coefficients
plus the effective degrees of freedom of the smoothers and recruitments,

$$
\texttt{nopar} = p_{\beta} + p_{\theta} + \sum_b \text{edf}_b \;(+\, \text{edf}_R) ,
$$

and `logLik()` returns $-\texttt{nlogl}$ with that many degrees of freedom, so
that

$$
\text{AIC} = 2\,\texttt{nlogl} + 2\,\texttt{nopar}
$$

is a conditional AIC for penalised fits and fits with random recruitment.

## 4. After fitting

### 4.1 Back-transformation

Quantities are returned on the original scale:

$$
\hat N_{ay} = \tilde N_{ay}\, e^{c_0}, \qquad
\hat C_{ay} = \frac{F_{ay}}{Z_{ay}}\big(1 - e^{-Z_{ay}}\big) \hat N_{ay},
$$

$$
\hat I_{say} = q_{say}\, e^{c_s - c_0}\, \hat N_{ay}\, e^{-t_s Z_{ay}},
\qquad
\hat I_{sy} = \sum_{a \in \mathcal A_s} q_{say}\, e^{c_s - c_0}\, w_{ay}\, \hat N_{ay}\, e^{-t_s Z_{ay}} .
$$

### 4.2 Prediction at new covariate values

`predict()` keeps the fitted bases and coefficients and evaluates the design
matrices at new covariate values $\mathbf x^\star$:

$$
\boldsymbol\eta^\star = \mathbf A(\mathbf x^\star)\, \hat{\boldsymbol\psi},
$$

then recomputes the population and predictions (Sections 2.3-2.4). Smoothers of
covariates are evaluated at the new values with the same knots, constraints and
coefficients.

### 4.3 Simulation

`simulate()` draws observations at the cells observed in the data:

$$
O^\star_i = \exp\!\big(\mu^\star_i + \varepsilon_i + c_f\big),
\qquad \varepsilon_i \sim \mathcal N\!\big(0,\; \sigma_i^2 / \omega_i\big),
$$

with $\mu^\star$ at the (possibly new) covariates. With `sample.pars = TRUE`
each simulation first draws the coefficients,
$\boldsymbol\psi^\star = \hat{\boldsymbol\psi} + \mathbf L \mathbf z$ with
$\mathbf L \mathbf L^\top = \widehat{\operatorname{Var}}(\hat{\boldsymbol\psi})$
and $\mathbf z \sim \mathcal N(\mathbf 0, \mathbf I)$.

### 4.4 Confidence intervals for derived quantities

`derivedCI()` uses the delta method on the log scale. For each derived quantity
$g(\boldsymbol\psi)$ (log SSB and log recruitment by year, log mean F over the
`fbar` ages, and log F at age and year),

$$
\operatorname{se}(g) = \sqrt{\mathbf J\, \widehat{\operatorname{Var}}(\hat{\boldsymbol\psi})\, \mathbf J^\top},
\qquad \mathbf J = \frac{\partial g}{\partial \boldsymbol\psi}\bigg|_{\hat{\boldsymbol\psi}},
$$

where $\mathbf J$ is computed exactly by automatic differentiation of
$g$, and

$$
\text{CI}_{1-\alpha} = \exp\!\big(g(\hat{\boldsymbol\psi}) \pm z_{1-\alpha/2}\, \operatorname{se}(g)\big).
$$

Mean F is $\bar F_y = \frac{1}{|\mathcal A_F|} \sum_{a \in \mathcal A_F} F_{ay}$ over
the `fbar` ages $\mathcal A_F$, and SSB is $\hat S_y = \tilde S_y e^{c_0}$.

## 5. Where the equations are implemented

| Section | Function (file) |
|---|---|
| 2.1 Centring and weights | `a4aData()`, `obsFrame()` (`R/data.R`) |
| 2.2 Design matrices | `a4aDesign()`, `predictDesign()` (`R/formula.R`); `a4aData()` (`R/data.R`) |
| 2.2 Linear predictors | `linearPredictors()` (`R/model.R`) |
| 2.3 Population dynamics | `population()` (`R/model.R`) |
| 2.4-2.6 Predictions, likelihood, SR | `a4aNllEta()` (`R/model.R`) |
| 2.7 Smoother prior | `penaltyNll()` (`R/model.R`); `penaltyBlock()` (`R/formula.R`) |
| 2.8 Objective | `a4aNll()` (`R/model.R`) |
| 3.1 ML fit | `fitA4a()`, `newtonPolish()` (`R/model.R`) |
| 3.2 Sparse Hessian | `hessianFun()`, `etaMap()` (`R/model.R`) |
| 3.3 Fellner-Schall | `fitSmoothing()`, `pseudoInverse()` (`R/model.R`) |
| 3.3 Laplace | `fitLaplace()` (`R/model.R`) |
| 3.3 edf, marginal likelihood | `fitA4a()` (`R/model.R`) |
| 3.4 Random recruitment | `fitA4a()`, `fitLaplace()` (`R/model.R`); `srList()` (`R/srmodels.R`) |
| 3.5 REML | `fitREML()`, `fitA4a()` (`R/model.R`) |
| 3.6 Convergence | `laplaceConvergence()`, `fitSmoothing()`, `fitA4a()` (`R/model.R`) |
| 3.7 Summaries | `sca()` (`R/sca.R`); `logLik()` (`R/a4aFit-class.R`) |
| 4.1 Back-transformation | `predictQuants()` (`R/sca.R`) |
| 4.2-4.3 Prediction, simulation | `predict()`, `simulate()`, `modelAt()` (`R/simulate.R`) |
| 4.4 Confidence intervals | `derivedCI()` (`R/uncertainty.R`) |

## References

Wood, S. N. and Fasiolo, M. (2017). A generalized Fellner-Schall method for
smoothing parameter optimization with application to Tweedie location, scale
and shape models. *Biometrics* 73, 1071-1081.

Wood, S. N. (2017). *Generalized Additive Models: An Introduction with R*, 2nd
edition. Chapman and Hall/CRC.

Kristensen, K., Nielsen, A., Berg, C. W., Skaug, H. and Bell, B. M. (2016).
TMB: Automatic differentiation and Laplace approximation. *Journal of
Statistical Software* 70(5), 1-21.

Jardim, E., Millar, C. P., Mosqueira, I., Scott, F., Osio, G. C., Ferretti, M.,
Alzorriz, N. and Orio, A. (2015). What if stock assessment is as simple as a
linear model? The a4a initiative. *ICES Journal of Marine Science* 72(1),
232-236.
