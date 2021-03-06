% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/epinow.R
\name{regional_epinow}
\alias{regional_epinow}
\title{Real-time Rt Estimation, Forecasting and Reporting by Region}
\usage{
regional_epinow(
  reported_cases,
  target_folder,
  target_date,
  case_limit = 20,
  cores = 1,
  summary = TRUE,
  summary_dir,
  region_scale = "Region",
  return_estimates = TRUE,
  ...
)
}
\arguments{
\item{reported_cases}{A data frame of confirmed cases (confirm) by date (date), and region (\code{region}).}

\item{target_folder}{Character string specifying where to save results (will create if not present).}

\item{target_date}{Date, defaults to maximum found in the data if not specified.}

\item{case_limit}{Numeric, the minimum number of cases in a region required for that region to be evaluated. Defaults to 20.}

\item{cores}{Numeric, defaults to 2. The number of cores to use when fitting the stan model.}

\item{summary}{Logical, should summary measures be calculated.}

\item{summary_dir}{A character string giving the directory
in which to store summary of results.}

\item{region_scale}{A character string indicating the name to give the regions being summarised.}

\item{return_estimates}{Logical, defaults to TRUE. Should estimates be returned.}

\item{...}{Pass additional arguments to \code{epinow}}
}
\value{
A list of output stratified at the top level into regional output and across region output summary output
}
\description{
Estimates Rt by region. See the documentation for \code{epinow} for further information.
}
\examples{
 \dontrun{
## Construct example distributions
generation_time <- list(mean = EpiNow2::covid_generation_times[1, ]$mean,
                        mean_sd = EpiNow2::covid_generation_times[1, ]$mean_sd,
                        sd = EpiNow2::covid_generation_times[1, ]$sd,
                        sd_sd = EpiNow2::covid_generation_times[1, ]$sd_sd,
                        max = 30)
                          
incubation_period <- list(mean = EpiNow2::covid_incubation_period[1, ]$mean,
                          mean_sd = EpiNow2::covid_incubation_period[1, ]$mean_sd,
                          sd = EpiNow2::covid_incubation_period[1, ]$sd,
                          sd_sd = EpiNow2::covid_incubation_period[1, ]$sd_sd,
                          max = 30)
                   
reporting_delay <- list(mean = log(10),
                        mean_sd = log(2),
                        sd = log(2),
                        sd_sd = log(1.1),
                        max = 30)
                        
## Uses example case vector
cases <- EpiNow2::example_confirmed[1:40]

cases <- data.table::rbindlist(list(
  data.table::copy(cases)[, region := "testland"],
  cases[, region := "realland"]))
  
## Run basic nowcasting pipeline
## Here we reduce the accuracy of the GP approximation in order to reduce runtime
out <- regional_epinow(reported_cases = cases,
                       generation_time = generation_time,
                       delays = list(incubation_period, reporting_delay),
                       gp = list(basis_prop = 0.1, boundary_scale = 2),
                       adapt_delta = 0.9,
                       samples = 2000, warmup = 200,
                       cores = 4, chains = 4)
}
}
