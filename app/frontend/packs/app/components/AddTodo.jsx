import React, { useRef } from 'react'

function AddTodo({ projectId, onSubmit }) {
  const titleInput = useRef(null)

  function handleSubmit() {
    const title = titleInput.current.value

    if (title.length == 0) return
    onSubmit({ title, project_id: projectId })
    titleInput.current.value = ""
  }

  return (
    <li className="list-group-item">
      <div className="input-group m-0">
        <input
          type="text" 
          ref={titleInput}
          defaultValue=""
          className="form-control" 
          placeholder="Start typing here to create a task..." />
        <button 
          className="btn btn-success" 
          onClick={handleSubmit}
          type="button" 
        >Add Task</button>
      </div>
    </li>
  )
}

export default AddTodo

