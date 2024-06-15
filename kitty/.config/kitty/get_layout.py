from kittens.tui.handler import result_handler
from typing import List
from kitty.boss import Boss
from kitty.window import Window


def main(args: List[str]) -> str:
    return "hui"


@result_handler(no_ui=False)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    draw_text_in_top_left(window, "huITAAAAA")


def draw_text_in_top_left(window: Window, text: str) -> None:
    # Top-left position
    top_left_x = 0  # First column
    top_left_y = 0  # First row

    # Move the cursor to the top-left position and write the text
    # The `\x1b7` saves the cursor position
    # The `\x1b8` restores the cursor position
    escape_sequence = f"\x1b7\x1b[{top_left_y + 1};{top_left_x + 1}H{text}\x1b8"
    window.write_to_child(escape_sequence)


# Ensure the script works when executed
if __name__ == "__main__":
    import sys
    main(sys.argv[1:])
