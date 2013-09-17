import sublime, sublime_plugin

class DuplicateLineUp(sublime_plugin.TextCommand):
	def run(self, edit):
		# Cache for clarity and speed
		view = self.view
		# Go through the regions in the selection
		for region in view.sel():
			# Make an expanded region to include the newlines
			lines = view.full_line(region)
			# Duplicate below current
			view.insert(edit, lines.b, view.substr(lines))
		
	def description():
		return "Copy the selection or line and place above the current selection or line. Cursor follows selection."

class DuplicateLineDown(sublime_plugin.TextCommand):
	def run(self, edit):
		# Cache for clarity and speed
		view = self.view
		# Go through the regions in the selection
		for region in view.sel():
			# Make an expanded region to include the newlines
			lines = view.full_line(region)
			# Duplicate above current
			view.insert(edit, lines.a, view.substr(lines))
		
	def description():
		return "Copy the selection or line and place below the current selection or line. Cursor follows selection."
