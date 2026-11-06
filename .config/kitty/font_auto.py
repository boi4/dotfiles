"""Smart cross-platform font selector for Kitty (macOS CoreText & Linux Fontconfig).

Prefers JetBrainsMono Nerd Font Mono when installed (e.g. macOS / personal Linux),
and falls back cleanly to DejaVu Sans Mono / Menlo / Source Code Pro when absent.
"""

CANDIDATES = (
    "JetBrainsMono Nerd Font Mono",
    "JetBrainsMono Nerd Font",
    "DejaVu Sans Mono",
    "Menlo",
    "Source Code Pro",
)


def pick_font() -> str | None:
    try:
        from kitty.fonts.common import all_fonts_map, family_name_to_key

        fmap = all_fonts_map(True).get("family_map", {})
        for name in CANDIDATES:
            if family_name_to_key(name) in fmap:
                return name
    except Exception:
        pass
    return None


chosen = pick_font()
if chosen:
    print(f'font_family      family="{chosen}"')
    print("bold_font        auto")
    print("italic_font      auto")
    print("bold_italic_font auto")
