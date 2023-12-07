// Local includes
#include "Material.h"
#include "Shader.h"
#include "Texture.h"
#include "Context.h"
// GLM includes
#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
// OPENGL includes
#include <GL/glew.h>
#include <GL/glut.h>
#include <iostream>
Material::~Material() {
	if (m_program != 0) {
		glDeleteProgram(m_program);
	}
}

void Material::init() {
	// TODO : Change shader by your
	m_texture_cube=1;
	m_texture_pbr=0;
	if(m_texture_cube==1) {m_program = load_shaders("shaders/unlit/vertex_reflex.glsl", "shaders/unlit/fragment_reflex.glsl");}
	else if(m_texture_pbr==1){m_program = load_shaders("shaders/unlit/vertex_pbr.glsl", "shaders/unlit/fragment_pbr.glsl");}
	else{m_program = load_shaders("shaders/unlit/vertex.glsl", "shaders/unlit/fragment.glsl");}
	check();
	// TODO : set initial parameters
	m_color = {1.0, 1.0, 1.0, 1.0};
	
	//m_texture = loadTexture2DFromFilePath("./data/glTF/texture.png");//./data/TwoSidedPlane_BaseColor.png ./data/fish/texture.png
	m_texture = loadTexture2DFromFilePath("./data/TwoSidedPlane_BaseColor.png");
	m_texture_normalMap= loadTexture2DFromFilePath("./data/TwoSidedPlane_Normal.png");
	//m_texture_normalMap= loadTexture2DFromFilePath("./data/glTF/normal.png");//./data/TwoSidedPlane_Normal.png //./data/gris2.png ./data/fish/normal.png
	//ToyCar_basecolor.png
	m_texture=loadTexture2DFromFilePath("./data/pbr/texture.png");
	m_normalMap = loadTexture2DFromFilePath("./data/pbr/normal.jpg");
    m_metalmap = loadTexture2DFromFilePath("./data/pbr/metallic.jpg");
    m_roughmap = loadTexture2DFromFilePath("./data/pbr/roughness.jpg");
    m_albedo = loadTexture2DFromFilePath("./data/pbr/albedo.jpg");
    m_ao = loadTexture2DFromFilePath("./data/pbr/ao.jpg");
}

void Material::clear() {
	// nothing to clear
	// TODO: Add the texture or buffer you want to destroy for your material
}

void Material::bind() {
	check();
	glUseProgram(m_program);
	internalBind();
}

void Material::internalBind() {
	// bind parameters

	glm::vec3 viewPos=Context::camera.getPosition();
	glm::vec3 lightPos(-1,1.,0.);
	glUniform3fv(glGetUniformLocation(m_program,"viewPos"),1,glm::value_ptr(viewPos));
	glUniform3fv(glGetUniformLocation(m_program,"lightPos"),1,glm::value_ptr(lightPos));
	GLint color = getUniform("color");
	glUniform4fv(color, 1, glm::value_ptr(m_color));
	if (m_texture != -1) {
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, m_texture);
		
		glUniform1i(getUniform("colorTexture"), GL_TEXTURE0);
	}
	if (m_texture_normalMap != -1) {
		glActiveTexture(GL_TEXTURE1);
		glBindTexture(GL_TEXTURE_2D, m_texture_normalMap);
		
		glUniform1i(getUniform("normalMap"), 1);
	}
	if (m_texture_cube != -1)
	{
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_CUBE_MAP, Context::skyboxTexture);
	}
	if (m_metalmap != -1) {
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, m_metalmap);
        glUniform1i(getUniform("metallicTexture"), 2);
    }
    if (m_albedo != -1) {
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, m_albedo);
        glUniform1i(getUniform("albedoTexture"), 3);
    }
    if (m_roughmap != -1) {
        glActiveTexture(GL_TEXTURE4);
        glBindTexture(GL_TEXTURE_2D, m_roughmap);
        glUniform1i(getUniform("roughnessTexture"), 4);
    }
    if (m_ao != -1) {
        glActiveTexture(GL_TEXTURE5);
        glBindTexture(GL_TEXTURE_2D, m_ao);
        glUniform1i(getUniform("aoTexture"), 5);
    }
	
	if (m_normalMap != -1) {
        glActiveTexture(GL_TEXTURE6);
        glBindTexture(GL_TEXTURE_2D, m_normalMap);
        glUniform1i(getUniform("normalTexture"), 6);
    }
	// TODO : Add your custom parameters here
}

void Material::setMatrices(glm::mat4& projectionMatrix, glm::mat4& viewMatrix, glm::mat4& modelMatrix)
{
	check();
	glUniformMatrix4fv(getUniform("projection"), 1, false, glm::value_ptr(projectionMatrix));
	glUniformMatrix4fv(getUniform("view"), 1, false, glm::value_ptr(viewMatrix));
	glUniformMatrix4fv(getUniform("model"), 1, false, glm::value_ptr(modelMatrix));
}

GLint Material::getAttribute(const std::string& in_attributeName) {
	check();
	return glGetAttribLocation(m_program, in_attributeName.c_str());
}

GLint Material::getUniform(const std::string& in_uniformName) {
	check();
	return glGetUniformLocation(m_program, in_uniformName.c_str());
}
