import React, { useState } from 'react'
import ProjectHeader from './ProjectHeader'
import Todo from './Todo'
import TodoService from '../services/TodoService'
import AddTodo from './AddTodo'

function Project({
  project,
  onDeleteProject,
  onRenameProject,
  onDeleteTodo
}) {
  const [todos, setTodos] = useState(project.todos)

  function handleDeleteTodo(todo) {
    setTodos(curr => [...curr.filter(i => i.id != todo.id)])

    TodoService.deleteTodo(
      todo,
      () => {},
      (error) => console.log(error)
    )
  }

  function handleCreateTodo(todo) {
    TodoService.createTodo(
      todo,
      (todo) => {
        setTodos(curr => [todo, ...curr])
      },
      (error) => console.log(error)
    )
  }

  function getTodoIndex(todo) {
    return todos.findIndex(el => el.id == todo.id)
  }

  function handleTodoUp(todo) {
    const position = getTodoIndex(todo)
    if (position == 0) return
    
    TodoService.updatePosition(
      todo,
      'up',
      (updated_todo) => {
        todo.position = updated_todo.position
      },
      (error) => console.log(error)
    )
    setTodos(items => {
      return swapItems(position, position - 1, [...items])
    })
  }

  function swapItems(a, b, array) {
    const temp = array[a]
    array[a] = array[b]
    array[b] = temp
    return array
  }

  function handleTodoDown(todo) {
    const position = getTodoIndex(todo)
    const last = todos.length - 1
    if (position >= last) return

    TodoService.updatePosition(
      todo,
      'down',
      (updated_todo) => {
        todo.position = updated_todo.position
      },
      (error) => console.log(error)
    )
    setTodos(items => {
      return swapItems(position, position + 1, [...items])
    })
  }

  return (
    <ul className="list-group mb-5 mt-5">
      <ProjectHeader
        project={project}
        onDeleteProject={onDeleteProject}
        onRenameProject={onRenameProject}
      />
      <AddTodo projectId={project.id} onSubmit={handleCreateTodo}/>
      {
        todos.map(todo => {
          return (
            <Todo
              key={todo.id} 
              todo={todo}
              onDeleteTodo={handleDeleteTodo}
              onUp={handleTodoUp}
              onDown={handleTodoDown}
            />
          )
        })
      }
    </ul>
  )
}

export default Project

