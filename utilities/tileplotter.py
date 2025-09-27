import json
import matplotlib.pyplot as plt

# Load the generated tile JSON
with open("map_tiles.json", "r") as f:
    tiles = json.load(f)

# Separate roads and buildings into two lists
road_x, road_y = [], []
building_x, building_y = [], []

for key, tile_type in tiles.items():
    x, y = map(int, key.split(","))
    if tile_type == "road":
        road_x.append(x)
        road_y.append(y)
    elif tile_type == "building":
        building_x.append(x)
        building_y.append(y)

# Create the plot
plt.figure(figsize=(8, 8))
ax = plt.gca()

# Plot buildings first so they appear on top of roads if overlapping
ax.scatter(road_x, road_y, marker="s", s=100, color="gray", label="Road")
ax.scatter(building_x, building_y, marker="s", s=100, color="saddlebrown", label="Building")

# Make it look like a grid
ax.set_aspect('equal')
plt.gca().invert_yaxis()  # optional: flip Y if you want top-down match with tilemaps
plt.grid(True, which='both', color='lightgray', linewidth=0.5, linestyle='--')

plt.legend()
plt.title("Tilemap Preview")
plt.show()
