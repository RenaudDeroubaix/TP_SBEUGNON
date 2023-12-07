IF(NOT EXISTS "/home/deroubaix/Bureau/MASTER/Master 1/HAI719I---Prog-3D/HAI719I---Prog-3D/tp_skybox/template/build/thirdparties/assimp/install_manifest.txt")
  MESSAGE(FATAL_ERROR "Cannot find install manifest: \"/home/deroubaix/Bureau/MASTER/Master 1/HAI719I---Prog-3D/HAI719I---Prog-3D/tp_skybox/template/build/thirdparties/assimp/install_manifest.txt\"")
ENDIF(NOT EXISTS "/home/deroubaix/Bureau/MASTER/Master 1/HAI719I---Prog-3D/HAI719I---Prog-3D/tp_skybox/template/build/thirdparties/assimp/install_manifest.txt")

FILE(READ "/home/deroubaix/Bureau/MASTER/Master 1/HAI719I---Prog-3D/HAI719I---Prog-3D/tp_skybox/template/build/thirdparties/assimp/install_manifest.txt" files)
STRING(REGEX REPLACE "\n" ";" files "${files}")
FOREACH(file ${files})
  MESSAGE(STATUS "Uninstalling \"$ENV{DESTDIR}${file}\"")
  EXEC_PROGRAM(
    "/usr/bin/cmake" ARGS "-E remove \"$ENV{DESTDIR}${file}\""
    OUTPUT_VARIABLE rm_out
    RETURN_VALUE rm_retval
    )
  IF(NOT "${rm_retval}" STREQUAL 0)
    MESSAGE(FATAL_ERROR "Problem when removing \"$ENV{DESTDIR}${file}\"")
  ENDIF(NOT "${rm_retval}" STREQUAL 0)
ENDFOREACH(file)
