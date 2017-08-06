describe 'ActiveResource', ->
  beforeEach ->
    jasmine.Ajax.install()

    window.onSuccess = jasmine.createSpy('onSuccess')
    window.onFailure = jasmine.createSpy('onFailure')
    window.onCompletion = jasmine.createSpy('onCompletion')

  afterEach ->
    jasmine.Ajax.uninstall()

  describe '::Base', ->
    describe '.links()', ->
      it 'returns the correct links', ->
        expect(MyLibrary::Product.links()).toEqual({ related: 'https://example.com/api/v1/products/' })

    describe 'with a different primaryKey', ->
      beforeEach ->
        class MyLibrary::Venue extends MyLibrary.Base
          this.className = 'Venue'
          this.queryName = 'venues'

          this.primaryKey = 'token'

          @hasOne 'owner'

        class MyLibrary::Owner extends MyLibrary.Base
          this.className = 'Owner'
          this.queryName = 'owners'

          @belongsTo 'venue'

      it 'constructs relationships with the primaryKey', ->
        @resource = MyLibrary::Venue.build(token: 'abc123')
        expect(@resource.buildOwner().venueId).toEqual('abc123')

      describe 'when interfacing', ->
        beforeEach ->
          MyLibrary::Venue.find(1)
          .done window.onSuccess

          jasmine.Ajax.requests.mostRecent().respondWith(JsonApiResponses.Venue.find.tokenized)
          @resource = window.onSuccess.calls.mostRecent().args[0]

        it 'builds the primaryKey into the resource retrieved', ->
          expect(@resource.token).toEqual('abc123')

        it 'is rendered in a resource document with the primaryKey', ->
          @resource.save()
          resourceDocument = {
            data: {
              token: 'abc123',
              type: 'venues',
              attributes: {},
              relationships: {}
            }
          }
          expect(jasmine.Ajax.requests.mostRecent().data()).toEqual(resourceDocument)
