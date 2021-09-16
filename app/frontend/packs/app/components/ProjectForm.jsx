import React, { useRef } from 'react'

function ProjectForm({ onCancel, onSubmit }) {
  const textInput = useRef("")
  
  function handleSubmit() {
    onSubmit(textInput.current.value)
  }

  function handleCancel() {
    onCancel()
  }

  return (
    <div className="input-group mb-3">
      <input
        type="text"
        ref={textInput}
        className="form-control"
        placeholder="New Project Name"/>
      <button
        className="btn btn-outline-success"
        type="button"
        onClick={handleSubmit}
      >Add</button>
      <button
        className="btn btn-outline-secondary"
        type="button"
        onClick={handleCancel}
      >Cancel</button>
    </div>
  )
}

export default ProjectForm

