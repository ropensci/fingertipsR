.onAttach <- function(libname, pkgname) {
  assign("fingertips_proxy", "default", envir=as.environment("package:fingertipsR"))

  tryCatch(
    {
      fingertips_ensure_api_available(proxy_settings = "default")
    }, error=function(e) {
      assign("fingertips_proxy", "none", envir=as.environment("package:fingertipsR"))
      tryCatch(
        {
          fingertips_ensure_api_available(proxy_settings = "none")
        }, error=function(e) {
          assign("fingertips_proxy", "default", envir=as.environment("package:fingertipsR"))
          packageStartupMessage("The API is currently unavailable, you may need to reload fingertipsR when the API becomes available.")
        }
      )
    }
  )
}
