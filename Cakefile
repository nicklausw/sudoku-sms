###
cakefile to build sudoku.

running it is just like a makefile.

to assemble: cake assemble
to link: cake link
to assemble and link: cake build
to clean up build files: cake clean
###

fs = require 'fs'
{exec} = require 'child_process'
{execSync} = require 'child_process'

delete_file = (file) ->
  fs.exists file , (existent) ->
    if existent
      fs.unlinkSync file

execute_program = (stuff) ->
  exec stuff, (err, stdout, stderr, callback) ->
    process.stdout.write stdout
    process.stderr.write stderr
    callback?() if callback


task 'assemble', ->
  execute_program 'wla-z80 -o sudoku.s sudoku.o'


task 'link', ->
  fs.openSync 'linkfile', 'w'
  fs.writeFileSync 'linkfile', '[objects]\nsudoku.o\n'

  execute_program 'wlalink -vd linkfile sudoku.sms'

task 'build', ->
  execSync 'cake assemble'
  execSync 'cake link'


# clean just gets rid of sudoku.o and linkfile.
task 'clean', ->
  delete_file('sudoku.o')
  delete_file('linkfile')
