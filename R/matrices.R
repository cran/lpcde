#######################################################################################
# This file contains code for all different matrix computations
# All functions are internal.
#######################################################################################

#' @title Sx Matrix (Internal Function)
#' @description S_x matrix constructed as described in *ref main paper*.
#' @param x_data data of covariates.
#' @param q maximum degree for x.
#' @param kernel_type type of kernel function.
#' @return S_x matrix
#' @keywords internal
S_x = function(x_data, q, kernel_type){
  # polynomial basis function
  poly_fun = function(x){poly_base(x, q)}

  # compute basis for all center and scaled data
  r = apply(x_data, 1, poly_fun)

  # create kernel function
  k_fun = function(x){kernel_eval(x, kernel_type)}

  # compute kernel value for all data points
  k = apply(x_data, 1, k_fun)

  # compute matrix
  sx_mat = (r%*%(t(r)*k))

  # output S^hat_x estimate
  return(sx_mat)
}

# #' @title Sy Matrix (Internal Function)
# #' @description S_y matrix constructed as described in *ref main paper*.
# #' @param y_data dataset.
# #' @param eval_pt evaluation point.
# #' @param p polynomial order.
# #' @param h bandwidth.
# #' @param kernel_type type of kernel function.
# #' @return S_y matrix
# #' @keywords internal
# S_y = function(y_data, eval_pt, p, h, kernel_type){
#   ymin = (min(y_data))
#   ymax = (max(y_data))
#   # generating upper and lower limits of integration
#   lower_lim = max((ymin-eval_pt)/h, -1)
#   upper_lim = min((ymax-eval_pt)/h, 1)
#   # looping over range of polynomials for which we need to evaluate integral
#   poly_list = matrix(0L, nrow = 2*p+1, ncol = 1)
#   if (lower_lim <= upper_lim){
#     for (i in 0:(2*p)){
#       # evaluating integral
#       poly_list[i+1, 1] = int_val(i, lower_lim, upper_lim, kernel_type)
#     }
#   }
#   # initialize matrix of polynomials to be filled
#   poly_mat = matrix(0L, nrow = (p+1), ncol = (p+1))
#   for (j in 1:(p+1)){
#     # fill matrix by selecting (p+1) consecutive elemnts of vector to fill each column
#     poly_mat[, j] = poly_list[j:(j+p)]
#   }
#   # matrix with all the denominators (factorials)
#   fact_mat = factorial(c(0:p))%*%t(factorial(c(0:p)))
#   # completing the S_y matrix
#   s_y = poly_mat/fact_mat
#   # return the S_y matrix
#   return(s_y)
# }

#' @title c_x vector (Internal Function)
#' @description c_x vector generated as described in main paper.
#' @param x_data data of covariates.
#' @param eval_pt evaluation point.
#' @param m order of polynomial.
#' @param q maximum degree for x.
#' @param h bandwidth.
#' @param kernel_type type of kernel function.
#' @keywords internal
c_x = function(x_data, eval_pt, m, q, h, kernel_type){
  # setting kernel and dimension of x data
  d = ncol(x_data)
  n = nrow(x_data)

  # generating a unit vector to get size of polynomial basis expansion
  e_base = basis_vec(eval_pt, q, 0)

  # initializing matrix
  c = matrix(0L, nrow = 1, ncol = length(e_base))

  # center and scale data
  v = (x_data - eval_pt)/h
  x_pol = x_data - eval_pt

  # simplify polynomial basis function
  poly_fun = function(v){poly_base(v, q)}

  # comput basis for all center and scaled data
  r = apply(v, 1, poly_fun)
  m_poly = x_pol^m/factorial(m)

  # evaluate kernel
  k_fun = function(x){kernel_eval(x, kernel_type)}

  # compute kernel value for all data points
  k = apply(v, 1, k_fun)

  # compute sum
  c = (t(t(r)*k)%*%m_poly)/(n*h^d)

  return(c)
}

#' @title c_y vector (Internal Function)
#' @description c_x vector generated as described in main paper.
#' @param y_data set of data points.
#' @param eval_pt evaluation point.
#' @param m order of derivative.
#' @param p maximum degree for y.
#' @param h bandwidth.
#' @param kernel_type type of kernel function.
#' @return vector object, c_y.
#' @keywords internal
c_y = function(y_data, eval_pt, m, p, h, kernel_type){
  # initialize empty array for filling with integrated values
  v = matrix(0L, nrow = p+1, ncol = 1)
  # setting limits of integration
  lower_lim = max((min(y_data)-eval_pt)/h, -1)
  upper_lim = min((max(y_data)-eval_pt)/h, 1)
  if (lower_lim < upper_lim){
    for (i in 0:p){
      # evaluted integrals
      v[i+1, 1] = int_val(i+m, lower_lim, upper_lim, kernel_type)/(factorial(m))
    }
  }
  return(v*(h^m))
}


#' @title T_x matrix (Internal Function)
#' @description constructing the Tx matrix as described in the supplemental appendix.
#' @param x_data data of covariates.
#' @param eval_pt evaluation point.
#' @param q polynomial order for covariates.
#' @param h bandwidth.
#' @param kernel_type type of kernel function.
#' @return matrix.
#' @keywords internal
T_x = function(x_data, eval_pt, q, h, kernel_type){
  x_data = as.matrix(x_data)
  # setting kernel and dimension of x data
  d = ncol(x_data)
  n = nrow(x_data)

  # generating a unit vector to get size of polynomial basis expansion
  e_base = basis_vec(eval_pt, q, 0)

  # initializing matrix
  t = matrix(0L, nrow = length(e_base), ncol = length(e_base))

  # simplify polynomial basis function
  poly_fun = function(v){poly_base(v, q)}

  # comput basis for all center and scaled data
  r = apply(x_data, 1, poly_fun)

  # creater kernel function
  k_fun = function(x){kernel_eval(x, kernel_type)}

  # compute kernel value for all data points
  k = apply(x_data, 1, k_fun)

  t =  (t(t(r)*k)%*%(t(r)*k))/(n)

  return(t)
}


#' @title T_y matrix (Internal Function)
#' @description constructing the Ty matrix as described in the supplemental appendix.
#' @param y_data vector of data points.
#' @param eval_pt evaluation point.
#' @param p polynomial order.
#' @param h bandwidth.
#' @param kernel_type type of kernel function. Currently only works with uniform kernel.
#' @return matrix Ty.
#' @keywords internal
T_y = function(y_data, yp_data, p, kernel_type){
  y_data = as.matrix(y_data)
  yp_data = as.matrix(yp_data)
  n = nrow(y_data)
  e_len = length(basis_vec(1, p, 0))

  r_p = function(v){poly_base(v, p)*kernel_eval(v, kernel_type)}
  rp_vec = apply(y_data, 1, r_p)
  ryp_vec = apply(yp_data, 1, r_p)

  v = matrix(0L, nrow=e_len, ncol=e_len)
  for (i in 1:n){
    for (j in 1:n){
      if (i==j){
        v = v
      }else {
        v = v + min(y_data[i], yp_data[j])*(as.matrix(rp_vec[,i])%*%t(as.matrix(ryp_vec[,j])))
      }
    }
  }
  return(v)
}