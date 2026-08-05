import re
import subprocess
from kitty.boss import Boss
from kittens.tui.handler import result_handler

def main(args: list[str]) -> str:
    pass

@result_handler(no_ui=True)
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    window = boss.window_id_map.get(target_window_id)
    if not window:
        return
        
    screen_text = window.as_text()
    lines = screen_text.splitlines()
    urls = []
    
    # Regex to aggressively strip combinations of spaces and box characters (\u2500-\u259F)
    # ^ matches the start of the line, $ matches the absolute end of the line.
    border_start = re.compile(r'^[\s\u2500-\u259F]+')
    border_end = re.compile(r'[\s\u2500-\u259F]+$')
    
    for i, line in enumerate(lines):
        # Clean both edges. This perfectly handles trailing "  │   " before a line break
        clean_line = border_start.sub('', line)
        clean_line = border_end.sub('', clean_line)
        
        # Strip literal '│ ' just in case it appears directly before a pattern internally
        clean_line = clean_line.replace('│ ', '')
        
        for match in re.finditer(r'https?://[^\s]+', clean_line):
            url = match.group(0)
            
            # If the URL doesn't touch the end of this stripped line, it didn't wrap
            if not clean_line.endswith(url):
                urls.append(url)
                continue
                
            current_url = url
            
            # Look ahead to stitch wrapped lines
            for j in range(i + 1, len(lines)):
                next_line = lines[j]
                
                # Stop stitching immediately if we hit the bottom corner of the current box
                if '╰' in next_line:
                    break
                    
                clean_next = border_start.sub('', next_line)
                clean_next = border_end.sub('', clean_next)
                clean_next = clean_next.replace('│ ', '')
                
                if not clean_next:
                    break 
                    
                first_part = clean_next.split(' ')[0]
                
                if first_part.startswith('http://') or first_part.startswith('https://'):
                    break
                    
                current_url += first_part
                
                # If there's a space, the URL finished and normal text resumed
                if ' ' in clean_next:
                    break
                    
            urls.append(current_url)
            
    if urls:
        last_url = urls[-1]
        last_url = last_url.rstrip(".,;)'\"]")
        subprocess.run(['open', '-a', 'Google Chrome', last_url])
