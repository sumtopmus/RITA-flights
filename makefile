.PHONY: all clean

all: us.json flights-stat.csv

clean:
	rm -rf build
	rm -f us.json
	rm -f flights-stat.csv

flights-stat.csv:
	python flights-stat.py

build/cb_2014_us_state_5m.zip:
	mkdir -p $(dir $@)
	curl -o $@.download \
		http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_state_5m.zip
	mv -f $@.download $@

build/cb_2014_us_state_5m.shp: build/cb_2014_us_state_5m.zip
	unzip -o -d $(dir $@) $<
	touch $@

build/states.json: build/cb_2014_us_state_5m.shp
	topojson \
		--simplify=.01 \
		--projection='width = 1000, height = 675, scale = 1200, d3.geo.albersUsa() \
			.scale(scale) \
			.translate([width / 2, height / 2])' \
		--out $@ \
		-- states=$<

us.json: build/states.json
	topojson-merge \
		--out $@ \
		--in-object=states \
		--out-object=country \
		-- $<