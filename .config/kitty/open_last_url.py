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
    
    # 1. Hard cutoff: Never read past the bottom-left corner of the CLI box
    if '╰' in screen_text:
        screen_text = screen_text.split('╰')[0]
        
    lines = screen_text.splitlines()
    urls = []
    
    for i, line in enumerate(lines):
        # 2. Strip edge borders and literal '│ ' before processing the line
        # This removes leading/trailing box characters and whitespace
        clean_line = re.sub(r'^[\s\u2500-\u259F]+', '', line)
        clean_line = re.sub(r'[\s\u2500-\u259F]+$', '', clean_line)
        # Explicitly remove '│ ' if it appears anywhere else (like right before a pattern)
        clean_line = clean_line.replace('│ ', '')
        
        for match in re.finditer(r'https?://[^\s]+', clean_line):
            url = match.group(0)
            
            # If the URL doesn't touch the end of this cleaned line, it didn't wrap
            if not clean_line.endswith(url):
                urls.append(url)
                continue
                
            current_url = url
            
            # 3. Look ahead for wrapped lines
            for j in range(i + 1, len(lines)):
                next_line = lines[j]
                
                # Clean the next line using the exact same logic
                clean_next = re.sub(r'^[\s\u2500-\u259F]+', '', next_line)
                clean_next = re.sub(r'[\s\u2500-\u259F]+$', '', clean_next)
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
