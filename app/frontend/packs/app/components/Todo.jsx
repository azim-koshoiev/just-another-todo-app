import React, { useState, useRef } from 'react'
import TodoService from '../services/TodoService'

function Todo({ todo, onDeleteTodo, onUp, onDown }) {
  const [completed, setCompleted] = useState(todo.complete)
  const [mode, setMode] = useState("norm")
  const [isShown, setIsShown] = useState(false)
  const titleInput = useRef("")
  const dateRef = useRef(null)

  function handleCompleted(event) {
    const checked = event.target.checked 
    setCompleted(checked)
    todo.complete = checked
    TodoService.updateTodo(
      todo,
      () => {},
      (error) => { console.error(error) }
    )
  }

  function handleEditMode() {
    setMode("edit")  
  }

  function handleEdit() {
    if (titleInput.current.value.length == 0) return
      
    const newTitle = titleInput.current.value
    const isTitleUpdated = newTitle != todo.title && newTitle.length != 0
    const isDateUpdated = dateRef.current.value

    if (!isTitleUpdated && !isDateUpdated) {
      setMode("norm")
      return
    }
    todo.title = newTitle
    todo.deadline = dateRef.current.value

    TodoService.updateTodo(
      todo,
      () => {},
      (error) => { console.log(error) }
    )     
    setMode("norm")
  }

  function handleDelete() {
    onDeleteTodo(todo)
  }

  function handleCancel() {
    setMode("norm")
  }

  function itemOnEditMode() {
    return (
      <>
        <input
          className="form-check-input m-3"
          name="isCompleted"
          type="checkbox"
          checked={completed}
          disabled
        />
        <input
          autoFocus
          className="m-0 flex-grow-1"
          defaultValue={todo.title}
          ref={titleInput}
        />
        <input 
          type="date" 
          ref={dateRef}
          defaultValue={todo.deadline}
        />
        <div className="btn-group" role="group">
          <button type="button" className="btn btn-light btn-sm"
            onClick={handleEdit}
          >Ok</button>
         <button type="button" className="btn btn-light btn-sm"
            onClick={handleCancel}
          >Cancel</button>
        </div>
      </>
    )
  }

  function itemOnViewMode() {
    return (
      <>
        <input
          className="form-check-input m-3"
          name="isCompleted"
          type="checkbox"
          checked={completed}
          onChange={handleCompleted}
        />
        <p className="lead m-0 flex-grow-1">
          { todo.title }
          { todo.deadline && <input type="date" disabled value={todo.deadline}/> }
        </p>
        { isShown && (
          <div className="btn-group" role="group">
            <button type="button" className="btn btn-light btn-sm"
              onClick={() => onUp(todo)}
            >Up</button>
            <button type="button" className="btn btn-light btn-sm"
              onClick={() => onDown(todo)}
            >Down</button>
            <button type="button" className="btn btn-light btn-sm"
              onClick={handleEditMode}
            >Edit</button>
           <button type="button" className="btn btn-light btn-sm"
              onClick={handleDelete}
            >Delete</button>
          </div>
        )}
      </>
    )
  }

  function itemByMode(mode) {
    if (mode == "norm") {
      return itemOnViewMode()
    } else if (mode == "edit") {
      return itemOnEditMode()
    }
  }

  return (
    <li 
      className="list-group-item d-flex align-items-center"
      onMouseEnter={() => { setIsShown(true) }}
      onMouseLeave={() => { setIsShown(false) }}
    >
      {itemByMode(mode)}
    </li>
  )
}

export default Todo

