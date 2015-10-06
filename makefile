build/world-countries-10m.zip:
	mkdir -p $(dir $@)
	curl -o $@.download http://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_0_map_subunits.zip
	mv -f $@.download $@

build/world-countries-10m.shp: build/world-countries-10m.zip
	mkdir -p $(dir $@)
	rm -f $(dir $@)/*.shp
	rm -f $(dir $@)/*.dbf
	unzip -o $(dir $@)/world-countries-10m *.shp -d $(dir $@)
	unzip -o $(dir $@)/world-countries-10m *.dbf -d $(dir $@)
	mv -f $(dir $@)/*.shp $(dir $@)/world-countries-10m.shp
	mv -f $(dir $@)/*.dbf $(dir $@)/world-countries-10m.dbf

build/world-countries-10m.json: build/world-countries-10m.shp
	node_modules/.bin/topojson \
		-o $@ \
		--projection='width = 960, height = 600, d3.geo.mercator()' \
		--simplify=.5 \
		-- counties=$<

build/flight-stats.csv:
	mkdir -p $(dir $@)
	python calculate-flight-stats.py