/* global cy */
describe('The landing page', function () {
  it.skip ('should load ', function () {
    cy.visit('/exist/Y/pr-app/index.html')
      .get('.alert')
      .contains('app.xql')
  })

})
