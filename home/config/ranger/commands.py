from ranger.api.commands import Command

class z(Command):
  """
  :z

  Jump to directory using fasd
  """
  def execute(self):
    args = self.rest(1).split()
    if args:
      directories = self._get_directories(*args)
      if directories:
        self.fm.cd(directories[0])
      else:
        self.fm.notify("No results from fasd", bad=True)

  def tab(self, tabnum: int):
    start, current = self.start(1), self.rest(1)
    for path in self._get_directories(*current.split()):
      yield start + path

  @staticmethod
  def _get_directories(*args):
    import subprocess
    output = subprocess.check_output(["fasd", "-dl", *args],
                                     universal_newlines=True)
    return output.strip().split("\n")

class fzf(Command):
  """
  :fzf

  Find a file using fzf.

  With a prefix argument select only directories.

  See: https://github.com/junegunn/fzf
  """
  def execute(self):
    import subprocess
    import os.path
    fzf = self.fm.execute_command("fzf", universal_newlines=True,
                                  stdout=subprocess.PIPE)
    stdout, stderr = fzf.communicate()
    if fzf.returncode == 0:
      fzf_file = os.path.abspath(stdout.rstrip('\n'))
      if os.path.isdir(fzf_file):
        self.fm.cd(fzf_file)
      else:
        self.fm.select_file(fzf_file)
