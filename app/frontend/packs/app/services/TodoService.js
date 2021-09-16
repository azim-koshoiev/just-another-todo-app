import axios from 'axios'
import CsrfToken from './helpers/CsrfToken'

function getTodos(project, onSuccess, onFail) {
  axios.get(`/api/v1/projects/${project.id}`)
    .then((response) => { onSuccess(response.data)
    }, (error) => {
      onFail(error)
    })
}

function createTodo(todo, onSuccess, onFail) {
  const config = CsrfToken.headerConfig()

  axios.post(`/api/v1/projects/${todo.project_id}/todos`, todo, config)
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
  }) }

function updateTodo(todo, onSuccess, onFail) {
  const config = CsrfToken.headerConfig()

  axios.put(`/api/v1/projects/${todo.project_id}/todos/${todo.id}`, todo, config)
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
  })

}

function deleteTodo(todo, onSuccess, onFail) {
  const config = CsrfToken.headerConfig()
  
  axios.delete(`/api/v1/projects/${todo.project_id}/todos/${todo.id}`, config)
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
  })
}

function updatePosition(todo, direction, onSuccess, onFail) {
  const config = CsrfToken.headerConfig()

  axios.patch(`/api/v1/todos/${todo.id}/position/${direction}`, {}, config)
    .then((response) => {
      onSuccess(response.data)
    }, (error) => {
      onFail(error)
  })
}
const TodoService = {
  getTodos,
  createTodo,
  updateTodo,
  deleteTodo,
  updatePosition,
}

export default TodoService 

