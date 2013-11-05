import sublime, sublime_plugin

class RepeatTextCommand(sublime_plugin.TextCommand):
    previousRepeat = 1
    
    def on_done(self, text):
        # Abort on empty input
        if not text: return
        count = int(text)
        # Abort if count is < 1
        if(count < 1): return
        # Run the command to change the text
        self.view.window().run_command("repeat_text", {"count": count})
    
    def on_change(self, text):
        pass
        
    def on_cancel(self):
        pass
        
    def run(self, edit, count=None):
        view = self.view
        if count is not None: 
            # Store the count for next time
            RepeatTextCommand.previousRepeat = count
            for region in view.sel():
                # If region is empty, then expand to the previous character
                if(region.size() == 0): region.a -= 1
                # If region is still empty, then expand to the next character
                if(region.size() == 0): region.b += 1
                # If region is still empty, then skip this region
                if(region.size() == 0): continue
                # Create the new text
                new_text = view.substr(region)*count
                view.replace(edit, region, new_text)
        else:
            view.window().show_input_panel("Times to repeat:", '', 
                self.on_done, 
                self.on_change, 
                self.on_cancel
                );
        
