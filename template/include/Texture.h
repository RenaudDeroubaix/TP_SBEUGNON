#ifndef TEXTURE_H_DEFINED
#define TEXTURE_H_DEFINED

#include <string>
#include <GL/glew.h>
#include <string>
#include <vector>
GLuint loadTexture2DFromFilePath(const std::string& path);
GLuint loadTexture2D1channelFromFilePath(const std::string& path) ;
void setDefaultTexture2DParameters(GLuint texture);
GLuint loadCubemap(const std::vector<std::string> & faces);
#endif
