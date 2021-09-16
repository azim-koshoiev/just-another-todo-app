import React, { useState, useRef } from 'react'

function ProjectHeader({ project, onDeleteProject, onRenameProject }) {
  const titleInput = useRef("")
  const [mode, setMode] = useState("norm")
  const [isShown, setIsShown] = useState(false)

  function handleRenameMode() {
    setMode("edit")
  }

  function handleRename() {
    const newTitle = titleInput.current.value

    if (newTitle.length == 0) return
    if (newTitle != project.title) {
      onRenameProject(project, newTitle)
    }
    setMode("norm")
  }

  function handleDelete() {
    onDeleteProject(project)
  }

  function handleCancel() {
    setMode("norm")
  }

  function itemInEditMode() {
    return (
      <div className="d-flex align-items-center justify-content-between">
        <input
          autoFocus
          className="form-control"
          defaultValue={project.title}
          ref={titleInput}
        />
        <div className="btn-group" role="group">
          <button
            type="button"
            className="btn btn-light btn-sm"
            onClick={handleRename}
          >Ok</button>
          <button
            type="button"
            className="btn btn-light btn-sm"
            onClick={handleCancel}
          >Cancel</button>
        </div>
      </div>
    )
  }

  function itemInViewMode() {
    return (
      <div className="d-flex align-items-center justify-content-between">
        <h5 className="m-2">{project.title}</h5>
        { isShown && (
          <div className="btn-group" role="group">
            <button
              type="button"
              className="btn btn-light btn-sm"
              onClick={handleRenameMode}
            >Rename</button>
            <button
              type="button"
              className="btn btn-light btn-sm"
              onClick={handleDelete}
            >Delete</button>
          </div>
        )}
      </div>
    )
  }

  function itemByMode(mode) {
    if (mode == "norm") {
      return itemInViewMode()
    } else {
      return itemInEditMode()
    }
  }

  return (
    <li
      className="list-group-item active"
      onMouseEnter={() => { setIsShown(true) }}
      onMouseLeave={() => { setIsShown(false) }}
    >
      {itemByMode(mode)}
    </li>
  )
}

export default ProjectHeader

