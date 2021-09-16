import axios from 'axios'
import CsrfToken from './helpers/CsrfToken'

function getProjects(onSuccess, onFail) {
  axios.get('/api/v1/projects')
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
    })
}

function createProject(project, onSuccess, onFail) {
  const config = CsrfToken.headerConfig()

  axios.post('/api/v1/projects', project, config)
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
  }) }

function updateProject(project, onSuccess, onFail) {
  const config = CsrfToken.headerConfig()

  axios.put(`/api/v1/projects/${project.id}`, project, config)
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
  })

}

function deleteProject(project, onSuccess, onFail) {
  const config = CsrfToken.headerConfig()
  
  axios.delete(`/api/v1/projects/${project.id}`, config)
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
  })
}

const ProjectService = {
  getProjects,
  createProject,
  updateProject,
  deleteProject,
}

export default ProjectService

