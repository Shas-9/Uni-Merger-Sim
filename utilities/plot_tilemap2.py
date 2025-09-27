import json
import matplotlib.pyplot as plt
import numpy as np

# --- CONFIGURATION ---
TILEMAP_FILE = "tilemap.json"
ELEMENTS_FILE = "named_locations_grid.json"  # optional, can be None

# Define colors for each tile ID as RGB tuples (0–255)
TILE_COLORS = {
    0: (255, 255, 255),      # white -> tile 0
    1: (0, 0, 0),            # black -> tile 1
    2: (208, 235, 184),      # green -> tile 2
    3: (192, 220, 235),      # blue
    4: (219, 219, 219),      # lightgrey
}

def plot_tilemap(grid, elements=None):
    height = len(grid)
    width = len(grid[0])

    # Convert tile IDs to normalized RGB array (0–1)
    img_array = np.zeros((height, width, 3), dtype=np.float32)

    for y in range(height):
        for x in range(width):
            tile_id = grid[y][x]
            rgb = TILE_COLORS.get(tile_id, (255, 0, 255))  # magenta for unknown
            img_array[y, x] = np.array(rgb) / 255.0  # normalize to 0-1

    fig, ax = plt.subplots()
    ax.imshow(img_array, interpolation="nearest")
    ax.set_xticks([])
    ax.set_yticks([])
    ax.set_title("Tilemap Visualization")

    if elements:
        for elem in elements:
            gx, gy = elem["grid_x"], elem["grid_y"]
            name = elem["name"]

            # Pick a different color based on type
            color = "red" if elem["type"] == "building" else "blue"

            # Slight offset so text isn't on the grid border
            ax.text(
                gx, gy, name,
                color=color,
                fontsize=6,
                ha="center",
                va="center",
                bbox=dict(facecolor="white", edgecolor="none", alpha=0.6, pad=0.5)
            )

    plt.show()

if __name__ == "__main__":
    with open(TILEMAP_FILE, "r") as f:
        grid = json.load(f)

    try:
        with open(ELEMENTS_FILE, "r") as f:
            elements = json.load(f)
    except FileNotFoundError:
        elements = None

    plot_tilemap(grid, elements)
