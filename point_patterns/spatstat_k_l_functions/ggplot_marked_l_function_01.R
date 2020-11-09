{
  # ---- packages ----
  require(spatstat)
  require(sp)
  require(here)
  require(rgdal)
  require(rspatial)
  require(ggplot2)
  require(data.table)
}


{
  # ---- load_data ----
  load(file = here("data", "r_objects", "l_env_crime_cat_burg_csr.Rdata"))
  load(file = here("data", "r_objects", "l_env_crime_cat_burg_relab.Rdata"))
}


{
  # ---- plot_params ----
  env_alpha_level = 0.05
  env_min_r = 50
  env_fill_colour = "black"
    env_fill_colour_alpha = 0.32
  
  env_plot_line_width = 1.0
  
  cross_l_line_types = c( 
    expected = "dashed",
    observed = "solid")
  
  cross_l_line_colours = c(
    expected = "black",
    observed = "steelblue"
  )
  
  cross_l_legend_name = "L(r)"
}


{
  # ---- envelope_plot_formatting ----
  
  scale_l_line_color =
    scale_color_manual(
      values = cross_l_line_colours,
      name = cross_l_legend_name)
  
  scale_l_linetype = scale_linetype_manual(values = (cross_l_line_types))
  scale_l_linetype = scale_linetype_manual(values = (c("dashed", "solid")))
  
  scale_env_ribbon =
    scale_fill_manual(
      values = c(adjustcolor(env_fill_colour, env_fill_colour_alpha), "transparent"),
      labels = NULL,
      name = paste0("H0\n", 100 * (1 - env_alpha_level), "% conf.\nenvelope"))
}


{
  l_env_crime_cat_burg_csr
  plot(l_env_crime_cat_burg_csr, . -r ~ r)
  plot(l_env_crime_cat_burg_csr, .~ r)
  l_env_crime_cat_burg_relab
  
  l_cross_env = l_env_crime_cat_burg_relab
  
  l_cross_sim_data = as.data.frame(attr(x = l_cross_env, which = "simfun"))[, -1]
  l_cross_env_dat = 
    data.table(
      r = l_cross_env$r,
      expected = l_cross_env$mmean,
      observed = l_cross_env$obs,
      lower = apply(l_cross_sim_data, 1, function(x) quantile(x, env_alpha_level / 2)),
      upper = apply(l_cross_sim_data, 1, function(x) quantile(x, 1 - env_alpha_level / 2)),
      env = "env")[r > env_min_r,]
  
  dat_env_lines = melt(l_cross_env_dat, id.vars = "r", measure.vars = c("expected", "observed"), variable.name = "L(r)")
  dat_env_lines
  
  env_lines = geom_line(
    data = dat_env_lines, 
    mapping = aes(x = r, y = value - r, colour = `L(r)`),
    size = env_plot_line_width)
  
  env_ribbon = geom_ribbon(
    mapping = aes(x = r, ymin = lower - r, ymax = upper - r, fill = env),
    data = l_cross_env_dat[r > env_min_r])
  
  ggplot() + 
    env_ribbon + scale_env_ribbon +
    env_lines + scale_l_linetype + scale_cross_l_line +
    ylab("L(r) - r")
}


