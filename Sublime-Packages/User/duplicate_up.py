import sublime, sublime_plugin

class DuplicateLineUp(sublime_plugin.TextCommand):
	def run(self, edit):
		self.view.run_command("duplicate_line")
		self.view.run_command("swap_line_up")

class DuplicateLineDown(sublime_plugin.TextCommand):
	def run(self, edit):
		self.view.run_command("duplicate_line")
