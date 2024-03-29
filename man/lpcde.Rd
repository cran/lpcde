% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lpcde.R
\name{lpcde}
\alias{lpcde}
\title{Local Polynomial Conditional Density Estimation}
\usage{
lpcde(
  x_data,
  y_data,
  y_grid = NULL,
  x = NULL,
  bw = NULL,
  p = NULL,
  q = NULL,
  p_RBC = NULL,
  q_RBC = NULL,
  mu = NULL,
  nu = NULL,
  rbc = TRUE,
  ng = NULL,
  normalize = FALSE,
  nonneg = FALSE,
  grid_spacing = "",
  kernel_type = c("epanechnikov", "triangular", "uniform"),
  bw_type = NULL
)
}
\arguments{
\item{x_data}{Numeric matrix/data frame, the raw data of covariates.}

\item{y_data}{Numeric matrix/data frame, the raw data of independent.}

\item{y_grid}{Numeric, specifies the grid of evaluation points in the y-direction. When set to default, grid
points will be chosen as 0.05-0.95 percentiles of the data, with a step size of 0.05 in
y-direction.}

\item{x}{Numeric, specifies the grid of evaluation points in the x-direction. When set to default,
the evaluation point will be chosen as the median of the x data.}

\item{bw}{Numeric, specifies the bandwidth used for estimation. Can be (1) a positive
scalar (common bandwidth for all grid points); or (2) a positive numeric vector/matrix
specifying bandwidths for each grid point (should be the same dimension as \code{grid}).}

\item{p}{Nonnegative integer, specifies the order of the local polynomial for \code{Y} used to
construct point estimates. (Default is \code{2}.)}

\item{q}{Nonnegative integer, specifies the order of the local polynomial for \code{X} used to
construct point estimates. (Default is \code{1}.)}

\item{p_RBC}{Nonnegative integer, specifies the order of the local polynomial for \code{Y} used to
construct bias-corrected point estimates. (Default is \code{p+1}.)}

\item{q_RBC}{Nonnegative integer, specifies the order of the local polynomial for \code{X} used to
construct bias-corrected point estimates. (Default is \code{q+1}.)}

\item{mu}{Nonnegative integer, specifies the derivative with respect to \code{Y} of the
distribution function to be estimated. \code{0} for the distribution function,
\code{1} (default) for the density funtion, etc.}

\item{nu}{Nonnegative integer, specifies the derivative with respect to \code{X} of the
distribution function to be estimated. Default value is \code{0}.}

\item{rbc}{Boolean. TRUE (default) for rbc calcuations, required for valid uniform inference.}

\item{ng}{int. number of grid points to be used. generates evenly space points over the support of the data.}

\item{normalize}{Boolean. False (default) returns original estimator, True normalizes estimates to integrate to 1.}

\item{nonneg}{Boolean. False (default) returns original estimator, True returns maximum of estimate and 0.}

\item{grid_spacing}{String. If equal to "quantile" will generate quantile-spaced grid evaluation points, otherwise will generate equally spaced points.}

\item{kernel_type}{String, specifies the kernel function, should be one of
\code{"triangular"}, \code{"uniform"}, and \code{"epanechnikov"}(default).}

\item{bw_type}{String, specifies the method for data-driven bandwidth selection. This option will be
ignored if \code{bw} is provided. Implementable with \code{"mse-dpi"} (default, mean squared error-optimal
bandwidth selected for each grid point)}
}
\value{
\item{Estimate}{ A matrix containing (1) \code{grid} (grid points),\cr
(2) \code{bw} (bandwidths),\cr
(3) \code{est} (point estimates with p-th and q-th order local polynomial),\cr
(4) \code{est_RBC} (point estimates with p_RBC-th and q_RBC-th order local polynomial),\cr
(5) \code{se} (standard error corresponding to \code{est}).
(6) \code{se_RBC} (standard error corresponding to \code{est_RBC}).}
\item{CovMat}{The variance-covariance matrix corresponding to \code{est}.}
\item{opt}{A list containing options passed to the function.}
}
\description{
\code{\link{lpcde}} implements the local polynomial regression based
conditional density (and derivatives). The estimator proposed in
Chandak, Cattaneo, Jansson and Ma.
Robust bias-corrected inference methods, both pointwise (confidence intervals) and
uniform (confidence bands), are also implemented.
}
\details{
Bias correction is only used for the construction of confidence intervals/bands, but not for point estimation.
The point estimates, denoted by \code{est}, are constructed using local polynomial estimates of order \code{p} and \code{q},
while the centering of the confidence intervals/bands, denoted by \code{est_RBC},
are constructed using local polynomial estimates of order
\code{p_RBC} and \code{q_RBC}. The confidence intervals/bands take the form:
\code{[est_RBC - cv * SE(est_RBC) , est_RBC + cv * SE(est_RBC)]}, where \code{cv} denotes
the appropriate critical value and \code{SE(est_RBC)} denotes an standard error estimate for
the centering of the confidence interval/band. As a result, the confidence intervals/bands
may not be centered at the point estimates because they have been bias-corrected.
Setting \code{p_RBC} equal to \code{p} and \code{q_RBC} to \code{q}, results on centered
at the point estimate confidence intervals/bands, but requires undersmoothing for
valid inference (i.e., (I)MSE-optimal bandwdith for the density point estimator cannot
be used). Hence the bandwidth would need to be specified manually when \code{q=p},
and the point estimates will not be (I)MSE optimal. See Cattaneo, Jansson and Ma
(2020a, 2020b) for details, and also Calonico, Cattaneo, and Farrell (2018, 2020)
for robust bias correction methods.

Sometimes the density point estimates may lie outside
of the confidence intervals/bands, which can happen if the underlying distribution exhibits
high curvature at some evaluation point(s). One possible solution in this case is to
increase the polynomial order \code{p} or to employ a smaller bandwidth.
}
\author{
Matias D. Cattaneo, Princeton University. \email{cattaneo@princeton.edu}.

Rajita Chandak (maintainer), Princeton University. \email{rchandak@princeton.edu}.

Michael Jansson, University of California Berkeley. \email{mjansson@econ.berkeley.edu}.

Xinwei Ma, University of California San Diego. \email{x1ma@ucsd.edu}.

Supported methods: \code{\link{coef.lpcde}}, \code{\link{confint.lpcde}},
\code{\link{plot.lpcde}}, \code{\link{print.lpcde}},
\code{\link{summary.lpcde}}, \code{\link{vcov.lpcde}}
}
