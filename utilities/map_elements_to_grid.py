import json
import math

# --- CONFIGURATION ---
ELEMENTS_FILE = "named_locations.json"   # your input file with pixel_x, pixel_y
BLOCK_SIZE = 8                   # must match the block_size used in tilemap generator
OUTPUT_FILE = "named_locations_grid.json"

def map_elements_to_grid(elements, block_size):
    updated = []
    for elem in elements:
        grid_x = int(elem["pixel_x"] // block_size * 3)
        grid_y = int(elem["pixel_y"] // block_size * 3)
        updated.append({
            "type": elem["type"],
            "name": elem["name"],
            "grid_x": grid_x,
            "grid_y": grid_y
        })
    return updated

if __name__ == "__main__":
    # Load elements file
    with open(ELEMENTS_FILE, "r") as f:
        elements = json.load(f)

    # Convert pixel → grid
    mapped_elements = map_elements_to_grid(elements, BLOCK_SIZE)

    # Save result
    with open(OUTPUT_FILE, "w") as f:
        json.dump(mapped_elements, f, indent=2)

    print(f"Done! Wrote {len(mapped_elements)} mapped elements to {OUTPUT_FILE}")
