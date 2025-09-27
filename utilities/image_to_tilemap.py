import json
from math import sqrt
from PIL import Image

def color_distance(c1, c2):
    """Euclidean distance between two RGB colors."""
    dr = c1[0] - c2[0]
    dg = c1[1] - c2[1]
    db = c1[2] - c2[2]
    return sqrt(dr * dr + dg * dg + db * db)

def get_average_color(img, x, y, block_size):
    """Compute average color of a block starting at (x,y)."""
    r_total = g_total = b_total = 0
    count = 0
    for yy in range(y, min(y+block_size, img.height)):
        for xx in range(x, min(x+block_size, img.width)):
            r, g, b = img.getpixel((xx, yy))[:3]
            r_total += r
            g_total += g
            b_total += b
            count += 1
    return (r_total // count, g_total // count, b_total // count)

def image_to_grid(image_path, block_size, color_map):
    """
    Convert image to 2D grid of tile IDs.
    color_map = [( (r,g,b), tile_id ), ...]
    """
    img = Image.open(image_path).convert("RGB")
    grid = []

    for y in range(0, img.height, block_size):
        row = []
        for x in range(0, img.width, block_size):
            avg = get_average_color(img, x, y, block_size)

            # Pick closest color from color_map
            closest_id = None
            closest_dist = float("inf")
            for base_color, tile_id in color_map:
                d = color_distance(avg, base_color)
                if d < closest_dist:
                    closest_dist = d
                    closest_id = tile_id
            row.append(closest_id)
        grid.append(row)

    return grid

if __name__ == "__main__":
    # Example usage
    IMAGE_PATH = "high_quality_map.png"
    BLOCK_SIZE = 8  # 4x4 pixels per grid square

    def tile_colors_to_list(tile_colors: dict):
        """
        Convert a dict like {id: (r,g,b)} to a list of ((r,g,b), id) tuples.
        """
        return [ (color, tile_id) for tile_id, color in tile_colors.items() ]


    TILE_COLORS = {
        0: (255, 255, 255),      # white -> tile 0
        1: (0, 0, 0),            # black -> tile 1
        2: (208, 235, 184),      # green -> tile 2
        3: (192, 220, 235),      # blue
        4: (219, 219, 219),      # lightgrey
    }
    COLOR_MAP = tile_colors_to_list(TILE_COLORS)

    # Define your base colors and tile IDs here
    # COLOR_MAP = [
    #     ((255, 255, 255), 0),  # white -> tile 0
    #     ((0, 0, 0), 1),        # black -> tile 1
    #     ((0, 255, 0), 2),      # green -> tile 2
    #     ((100, 100, 100), 3),        # darkgray
    #     ((200, 200, 200), 4),        # lightgrey
    # ]

    grid = image_to_grid(IMAGE_PATH, BLOCK_SIZE, COLOR_MAP)

    with open("tilemap.json", "w") as f:
        json.dump(grid, f, indent=2)

    print(f"Done! Wrote grid {len(grid)}x{len(grid[0])} to tilemap.json")
