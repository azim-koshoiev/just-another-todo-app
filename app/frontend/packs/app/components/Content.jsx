import React, { useState, useEffect } from 'react'
import Project from './Project'
import AddProject from './AddProject'
import ProjectForm from './ProjectForm'
import ProjectService from '../services/ProjectService'

function Content() {
  const [projects, setProjects] = useState([])

  useEffect(() => {
    ProjectService.getProjects(
      (projects) => {
        setProjects(projects)
      }
    ), (error) => {
      console.error(error)
    }
  }, [])

  const [showForm, setShowForm] = useState(false)
  
  function showProjectForm() {
    setShowForm(true)
  }

  function hideProjectForm() {
    setShowForm(false)
  }

  function handleSubmitProject(title) {
    if (title.length != 0) {
      hideProjectForm()

      ProjectService.createProject(
        { title },
        (project) => { setProjects([...projects, project]) },
        (error) => { console.error(error) }
      )
    }
  }

  function handleDeleteProject(project) {
    setProjects((projects) => {
      return [...projects.filter(p => p.id != project.id)]
    })

    ProjectService.deleteProject(
      project,
      () => {},
      (error) => { console.log(error) }
    )
  }

  function handleRenameProject(project, newTitle) {
    project.title = newTitle

    ProjectService.updateProject(
      project,
      () => {},
      (error) => { console.log(error) }
    )
  }

  return (
    <div>
      {projects.map(project => (
        <Project
          key={project.id}
          project={project}
          onDeleteProject={handleDeleteProject}
          onRenameProject={handleRenameProject}
        />
      ))}
      { showForm &&
        <ProjectForm
          onCancel={hideProjectForm}
          onSubmit={handleSubmitProject}
        /> }
      <AddProject onButtonClick={showProjectForm} />
    </div>
  )
}

export default Content
