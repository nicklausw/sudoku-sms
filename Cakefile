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
      fs.unlink file


task 'assemble', ->
  # run the assembler
  exec 'wla-z80 -o sudoku.s sudoku.o', (err, stdout, stderr) ->
    process.stdout.write stdout if stdout
    process.stderr.write stderr if stderr


task 'link', ->
  fs.openSync 'linkfile', 'w' # truncate linkfile
  fs.writeFileSync "linkfile", "[objects]\nsudoku.o" # write to linkfile

  # run the linker
  exec 'wlalink -vd linkfile sudoku.sms', (err, stdout, stderr) ->
    process.stdout.write stdout if stdout
    process.stderr.write stderr if stderr

task 'build', ->
  execSync 'cake assemble'
  execSync 'cake link'

# clean just gets rid of sudoku.o and linkfile.
task 'clean', ->
  delete_file('linkfile')
  delete_file('sudoku.o')
