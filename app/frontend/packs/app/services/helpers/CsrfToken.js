function getHeaderConfig() {
  const csrfToken = document.querySelector('[name=csrf-token]')
  const config = {
    headers: {
      'x-csrf-token': csrfToken.content,
    }
  }
  return config
}

const CsrfToken = {
  headerConfig: getHeaderConfig
}

export default CsrfToken

