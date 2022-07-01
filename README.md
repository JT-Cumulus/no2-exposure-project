# Air Pollution Exposure Thesis Project
Project files for my Utrecht University Thesis Project. Only includes processed files and not raw data due to data sensitivity.
In general Ams = Amsterdam and Utr = Utrecht.

# File Overview
Jupyter Notebook files were used to calculate exposure under residential and mobility conditions in Amsterdam and Utrecht. 
'MobilityNO2Ams.ipynb' was used to generate OSM routing geometries in Amsterdam and evaluate the mobility exposure at these locations.
'MobilityNO2Utr.ipynb' was used to generate OSM routing geometries in Utrecht and evaluate the mobility exposure at these locations.
'StaticalAnalysis.ipynb' was used to generate hourly NO2 exposure using the formula mentioned in the main text. Additionally, it was also used to aggregate the mean exposures for each unique ID.
The R file was used to perform the statistical analysis of the results as well as generate visuals for the data.

# R File
For column names:
Res_no2 = Average_NO2 = Rivm_nsl_2, whereby they all represent the residential exposure measurements.
Mob_no2 = current_no2_y, where they represent the mobility exposure measurements.

# Data
Contains OSM geometry, which are the osm generated vector polygons representing all discrete routes undertaken by ODiN participants. Journey_geom_[mode] represents the Amsterdam routes and the mode of transport. Utr_[mode]_only represents the Utrecht routes and the mode of transport.

# QGIS
Handling of raster data was performed with QGIS. Zonal statistics were also handled by QGIS. Utrecht's NO2 data was available in raster data which resulted in the creation of the buffer files found in the directory. These buffer files convert the OSM geometries from lines into shapes using a 5m buffer such that zonal statistics become possible.

# Processed data
Contains all the outputs of the analysis in the present study.
