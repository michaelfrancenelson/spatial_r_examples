{
  # ---- packages ----
  require(spatstat)
  require(sp)
  require(here)
  require(rgdal)
  require(rspatial)
}



{
  # ---- r_help_example ----
  data(amacrine)
  amacrine
  L <- Lcross(amacrine, "off", "on")
  plot(L)
}


# ---- sandbox ----
{
  
  if (!require("rspatial")) devtools::install_github('rspatial/rspatial')
  library(rspatial)
  city <- sp_data('city')
  crime <- sp_data('crime')
  
  load(url("http://github.com/mgimond/Spatial/raw/master/Data/ppa.RData"))
  class(starbucks)
  str(starbucks)
  class(ma)
  class(pop)
  s    <- readOGR(".", "MA")  # Don't add the .shp extension
  ma    <- as(s, "owin")
  img  <- raster("pop_sqmile.img")
  pop  <- as.im(img)
}

{
  # ---- spatial_points_sp_example ----
  
  
  
  
  
  
  
  
  
  
  readOGR(here("data", "opuntia.csv"))
  
  Kcross()
  
  
  
}


# ---- sp_example_data ---
{
  
  # data from rspatial
  city = sp_data('city')
  crime = sp_data('crime')
  
  # get rid of crime points outside the city polygon, to make the examples simpler
  require(rgeos)
  crime = crime[gIntersects(crime, city, byid = TRUE)[1, ], ]
  
  
  if (FALSE)
  {
    # use a subset to speed up the example
    n_pts = 300
    set.seed(1)
    crime_subset = crime[sample(length(crime), n_pts), ]
  }
  
  # Keep only three types to simplify the example
  table(crime$CATEGORY)
  
  
}

{
  # ---- owin_from_sp ----
    
  # you need maptools to quickly build an owin from a SpatialPolygons*
  require(maptools)
  
  # first create an owin object
  city_owin = as.owin(city)
  plot(city_owin)
}

{
  # ---- l_fun_envelope ----
  
  # build a ppp from coordinates of an spdf:
  crime_ppp = as.ppp(
    X = coordinates(crime_subset),
    # X = coordinates(crime_subset),
    W = city_owin)
  
  
  
  set.seed(1)
  l_env_crime = envelope(
    crime_ppp, 
    fun = Lest,
    nsim = 99,
    rank = 1,
    correction = "iso",
    global = FALSE,
    verbose = TRUE)
  
  plot(l_env_crime)  
  
}


{
  # ---- marked_l_fun_envelope ----
  
  # build a ppp from coordinates of an spdf:
  crime_ppp_category = as.ppp(
    X = coordinates(crime_subset),
    W = city_owin)
  
  # add marks
  # if marks aren't a factor, the ppp object won't be 'multitype' and the cross functions will fail
  marks(crime_ppp_category) = factor(crime_subset$CATEGORY)
  crime_ppp_category
  
  plot(crime_ppp_category)
  table(crime_ppp_category$marks)
  
  
  # random relabling
  
  set.seed(1)
  l_env_crime_cat_burg_2 = envelope(
    crime_ppp_category, 
    fun = Lcross,
    # simulate = expression(rlabel(crime_ppp_category)),
    nsim = 99,
    rank = 1,
    global = FALSE,
    verbose = TRUE,
    savefuns = TRUE,
    funargs = list(
      correction = "iso", 
      i = "Residential Burglary",
      j = "Vehicle Burglary")
    )
  
  plot(l_env_crime_cat_burg, . -r ~ r)  
  plot(l_env_crime_cat_burg_2, . -r ~ r)  
  
}
