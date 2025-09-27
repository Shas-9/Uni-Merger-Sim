import json
import osmnx as ox
import pyproj
from shapely.geometry import Point, Polygon

import matplotlib.pyplot as plt

# 1. Load and filter street network
graph = ox.graph_from_xml("data/uni_adel.osm", simplify=True)
edges_with_highway = [(u, v, k) for u, v, k, d in graph.edges(keys=True, data=True) if "highway" in d]
street_graph = graph.edge_subgraph(edges_with_highway)

# 2. Load different features
buildings = ox.features_from_xml("data/uni_adel.osm", tags={"building": True})

# Green areas (parks, grass, forest, gardens, etc.)
green_tags = {
    "landuse": ["grass", "forest", "recreation_ground"],
    "leisure": ["park", "garden"],
    "natural": ["wood", "scrub"]
}
green_areas = ox.features_from_xml("data/uni_adel.osm", tags=green_tags)

# Water bodies (rivers, lakes, ponds)
water_tags = {
    "natural": ["water"],
    "waterway": ["river", "stream", "canal"],
}
water_areas = ox.features_from_xml("data/uni_adel.osm", tags=water_tags)

# 3. Plot everything together
# fig, ax = ox.plot_graph(
#     street_graph,
#     node_size=0,
#     edge_color="black",
#     edge_linewidth=0.7,
#     bgcolor="white",
#     figsize=(12, 12),
#     dpi=300,
#     show=False,
#     close=False,
# )

fig, ax = plt.subplots(figsize=(12, 12))

ax.set_aspect("equal")
plt.ylim(bottom=-34.923, top=-34.9159)
plt.xlim(left=138.601, right=138.609)

# Plot water (below everything else for realism)
if len(water_areas) > 0:
    water_areas.plot(ax=ax, facecolor="#a6cee3", edgecolor="none", alpha=0.7)

# Plot greenery
if len(green_areas) > 0:
    green_areas.plot(ax=ax, facecolor="#b2df8a", edgecolor="none", alpha=0.6)

# Plot buildings (on top)
if len(buildings) > 0:
    buildings.plot(ax=ax, facecolor="lightgray", edgecolor="none", alpha=0.8)

# 4. Get transform from data → pixels
transform = ax.transData

# 5. Build arrays but convert to pixel coords
building_data = []
for idx, row in buildings.iterrows():
    if "name" in row and isinstance(row["name"], str):
        centroid = row.geometry.centroid
        pixel_x, pixel_y = transform.transform((centroid.x, centroid.y))
        building_data.append({
            "type": "building",
            "name": row["name"],
            "pixel_x": pixel_x,
            "pixel_y": pixel_y
        })

green_data = []
for idx, row in green_areas.iterrows():
    if "name" in row and isinstance(row["name"], str):
        centroid = row.geometry.centroid
        pixel_x, pixel_y = transform.transform((centroid.x, centroid.y))
        green_data.append({
            "type": "green_area",
            "name": row["name"],
            "pixel_x": pixel_x,
            "pixel_y": pixel_y
        })

# Combine and print example
all_features = building_data + green_data
print(all_features[:5])

with open("named_locations.json", "w") as f:
    json.dump(all_features, f, indent=2)


ax.set_axis_off()  # removes x/y axes
plt.show()
fig.savefig("high_quality_map.png", dpi=500, bbox_inches="tight")


# # CONFIG
# METERS_PER_TILE = 5.0  # 1 tile = 5 meters

# # Load data
# graph = ox.graph_from_xml("data/uni_adel.osm", simplify=True)
# gdf_buildings = ox.features_from_xml("data/uni_adel.osm", tags={"building": True})
# # gdf_buildings = ox.geometries_from_xml("data/uni_adel.osm", tags={"building": True})

# # Projector to convert lat/lon -> meters
# projector = pyproj.Transformer.from_crs("EPSG:4326", "EPSG:3857", always_xy=True).transform

# def snap_to_grid(x, y):
#     tx = int(x // METERS_PER_TILE)
#     ty = int(y // METERS_PER_TILE)
#     return (tx, ty)

# # 1. Collect roads as tile coordinates
# road_tiles = set()
# for u, v, data in graph.edges(data=True):
#     if "geometry" in data:
#         for (lon, lat) in data["geometry"].coords:
#             x, y = projector(lon, lat)
#             road_tiles.add(snap_to_grid(x, y))

# # 2. Collect buildings as tile coordinates
# building_tiles = set()
# for geom in gdf_buildings.geometry:
#     if geom.geom_type == "Polygon":
#         for lon, lat in geom.exterior.coords:
#             x, y = projector(lon, lat)
#             building_tiles.add(snap_to_grid(x, y))

# # 3. Merge results into a single dict
# tiles = {}
# for (tx, ty) in road_tiles:
#     tiles[f"{tx},{ty}"] = "road"

# for (tx, ty) in building_tiles:
#     # If a building overlaps a road, keep building tile (or choose road if you prefer)
#     tiles[f"{tx},{ty}"] = "building"

# # 4. Export as JSON
# with open("map_tiles.json", "w") as f:
#     json.dump(tiles, f, indent=2)
