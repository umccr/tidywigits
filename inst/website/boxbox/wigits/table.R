#' @export
down_button <- function(d, nm) {
  downloadthis::download_this(
    .data = d,
    output_name = nm,
    output_extension = ".csv",
    button_label = "CSV Download",
    button_type = "primary"
  )
}
