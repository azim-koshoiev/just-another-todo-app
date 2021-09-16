import React from 'react'

function AddProject({ onButtonClick }) {
  return (
    <div className="d-flex justify-content-center m-4">
      <button
        type="button" 
        className="btn btn-primary"
        onClick={onButtonClick}
      >Add TODO List</button>
    </div>
  )
}

export default AddProject

