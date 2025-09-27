import json
import matplotlib.pyplot as plt
import numpy as np

# --- CONFIGURATION ---
TILEMAP_FILE = "tilemap.json"

# Define colors for each tile ID as RGB tuples (0–255)
TILE_COLORS = {
    0: (255, 255, 255),      # white -> tile 0
    1: (0, 0, 0),            # black -> tile 1
    2: (208, 235, 184),      # green -> tile 2
    3: (192, 220, 235),      # blue
    4: (219, 219, 219),      # lightgrey
}

# rgba(219, 219, 219)
# rgba(208, 235, 184) green
# rgba(208, 235, 184) blue
# rgba()
def plot_tilemap(grid):
    height = len(grid)
    width = len(grid[0])

    # Convert tile IDs to normalized RGB array (0–1)
    img_array = np.zeros((height, width, 3), dtype=np.float32)

    for y in range(height):
        for x in range(width):
            tile_id = grid[y][x]
            rgb = TILE_COLORS.get(tile_id, (255, 0, 255))  # magenta for unknown
            img_array[y, x] = np.array(rgb) / 255.0  # normalize

    plt.imshow(img_array, interpolation="nearest")
    plt.axis("off")
    plt.title("Tilemap Visualization")
    plt.show()

if __name__ == "__main__":
    with open(TILEMAP_FILE, "r") as f:
        grid = json.load(f)

    plot_tilemap(grid)
