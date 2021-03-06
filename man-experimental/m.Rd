\name{m}
\alias{m}
\alias{m,a4aM-method}
\title{Method to compute natural mortality}
\arguments{
  \item{object}{a \code{a4aM} object}

  \item{grMod}{a \code{a4aGr} object to get the K from}

  \item{...}{placeolder for covariates of the models. The
  names must match formula's variables (not parameters),
  with the exception of the \code{a4aGr} individual growth
  model. To use a growth model it must be called
  \code{grMod} and be of class \code{a4aGr}, in which case
  the parameters will be matched. The main objective if to
  be able to use \code{K} from von Bertalanffy models in
  M.}
}
\value{
  a \code{FLQuant} object
}
\description{
  Method to compute natural mortality
}
\details{
  If the models use \code{age} and/or \code{year} as terms
  the method expects these to be included in the call (will
  be passed through the \ldots argument). If they're not,
  the method will use the range slot to work out the ages
  and/or years that should be predicted. If \code{age}
  and/or \code{year} are not model terms, the method will
  use the range slot to define the dimensions of the
  resulting \code{M} \code{FLQuant}.
}
\examples{
age <- 0:15
k <- 0.4
shp <- eval(as.list(~exp(-age-0.5))[[2]], envir=list(age=age))
lvl <- eval(as.list(~1.5*k)[[2]], envir=list(k=k))
M <- shp*lvl/mean(shp)
mod1 <- FLModelSim(model=~exp(-age-0.5))
mod2 <- FLModelSim(model=~1.5*k, params=FLPar(k=0.4))
m1 <- a4aM(shape=mod1, level=mod2)
rngmbar(m1)<-c(0,15)
m(m1, age=0:15)
all.equal(M, c(m(m1, age=0:15)))
# another example m
rngmbar(m1) <- c(2,4)
m(m1, age=2:10)
# with iters
mod2 <- FLModelSim(model=~k^0.66*t^0.57, params=FLPar(matrix(c(0.4,10,0.5,11), ncol=2, dimnames=list(params=c("k","t"), iter=1:2))), vcov=array(c(0.004, 0.00,0.00, 0.001), dim=c(2,2,2)))
m2 <- a4aM(shape=mod1, level=mod2)
m(m2, age=0:10)
m3 <- a4aM(shape=mod1, level=mvrnorm(100, mod2))
m(m3, age=0:15)
mod1 <- FLModelSim(model=~exp(-age-0.5))
mod3 <- FLModelSim(model=~1+b*v, params=FLPar(b=0.05))
mObj <- a4aM(shape=mod1, level=mvrnorm(100, mod2), trend=mod3, range=c(min=0,max=15,minyear=2000,maxyear=2003,minmbar=0,maxmbar=0))
m(mObj, v=1:4)
}

