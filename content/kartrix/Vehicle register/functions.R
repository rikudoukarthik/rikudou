
# total distance driven -------------------------------------------------------------

get_tot_dist <- function(vehicle = "overall") {
  
  # total distance driven with each vehicle
  tot_dist <- data_veh %>% 
    filter(!is.na(ODO) & DRIVER == "Self") %>% 
    group_by(VEHICLE) %>% 
    reframe(TOT.DIST = max(ODO.ME.CUM))
  
  if (vehicle == "overall") {
    
    # since ODO.ME.CUM includes unlogged km before logging, need to subtract
    unlog_pre <- unlogged %>% 
      filter(DATE == "Before") %>% 
      reframe(DISTANCE = sum(DISTANCE)) %>% 
      pull(DISTANCE)
    
    logged <- tot_dist %>% 
      reframe(TOT.DIST.L = sum(TOT.DIST) - unlog_pre)
    
    unlogged <- unlogged %>%
      distinct(VEHICLE, DISTANCE) %>% 
      reframe(TOT.DIST.U = sum(DISTANCE))
    
  } else {
    
    # since ODO.ME.CUM includes unlogged km before logging, need to subtract
    unlog_pre <- unlogged %>% 
      filter(VEHICLE == vehicle, DATE == "Before") %>% 
      reframe(DISTANCE = sum(DISTANCE)) %>% 
      pull(DISTANCE)
    
    logged <- tot_dist %>% 
      filter(VEHICLE == vehicle) %>% 
      reframe(TOT.DIST.L = TOT.DIST - unlog_pre)
    
    unlogged <- unlogged %>%
      group_by(VEHICLE) %>% 
      reframe(DISTANCE = sum(DISTANCE)) %>% 
      filter(VEHICLE == vehicle) %>% 
      distinct(DISTANCE) %>% 
      mutate(DISTANCE = replace_na(DISTANCE, 0)) %>% 
      rename(TOT.DIST.U = DISTANCE)
    
    # if vehicle has no unlogged, above df will be empty
    if (nrow(unlogged) == 0) {
      unlogged <- tibble(TOT.DIST.U = 0)
    }
    
  }
  
  out <- bind_cols(logged, unlogged) %>% 
    mutate(TOT.DIST = TOT.DIST.L + TOT.DIST.U) %>% 
    mutate(across(everything(), 
                  ~ format(., scientific = FALSE, big.mark = ",")))
  
  return(out)
  
}


# overall stats ---------------------------------------------------------------------

get_overall_stats <- function() {

  out <- tibble(temp = "Distance driven (km)") %>% 
    bind_cols(get_tot_dist()) %>% 
    magrittr::set_colnames(c("", "Logged", "Unlogged", "Total"))
  
  return(out)
  
}
