require "rails_helper"

RSpec.describe 'admin application show page' do

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_2.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @app_1 = Application.create!(name: 'Billy',
      city: 'Denver',
      street_address: '123 lion st',
      state: 'CO',
      zip: 12345,
      description: "I like dogs",
      status: "Pending"
    )
    @app_2 = Application.create!(name: 'Hugh',
      city: 'Aurora',
      street_address: '789 maple',
      state: 'CO',
      zip: 12365,
      description: 'Dogs r neat',
      status: "Pending"

    )

    @pet_1.applications << @app_1
    @pet_2.applications << @app_1
    @pet_3.applications << @app_1

    @pet_4.applications << @app_2


  end


  it 'can approve a pet for adoption' do
    visit "/admin/applications/#{@app_1.id}"

    expect(page).to have_button("Approve #{@pet_1.name}")
    expect(page).to have_button("Approve #{@pet_2.name}")
    expect(page).to have_button("Approve #{@pet_3.name}")

    click_button("Approve #{@pet_1.name}")

    expect(current_path).to eq("/admin/applications/#{@app_1.id}")


    expect(page).to_not have_button("Approve #{@pet_1.name}")
    expect(page).to have_button("Approve #{@pet_2.name}")
    expect(page).to have_content("#{@pet_1.name} is approved")
  end

  it 'can reject a pet for adoption' do
    visit "/admin/applications/#{@app_1.id}"

    expect(page).to have_button("Reject #{@pet_1.name}")
    expect(page).to have_button("Reject #{@pet_2.name}")
    expect(page).to have_button("Reject #{@pet_3.name}")

    click_button("Reject #{@pet_1.name}")

    expect(current_path).to eq("/admin/applications/#{@app_1.id}")

    expect(page).to_not have_button("Approve #{@pet_1.name}")
    expect(page).to_not have_button("Reject #{@pet_1.name}")
    expect(page).to have_button("Reject #{@pet_2.name}")
    expect(page).to have_content("#{@pet_1.name} is rejected")
  end

  it 'applications are independent' do
    @pet_1.applications << @app_2

    visit "/admin/applications/#{@app_1.id}"

    click_button("Reject #{@pet_1.name}")

    visit "/admin/applications/#{@app_2.id}"

    expect(page).to_not have_content("#{@pet_1name} is rejected")
    expect(page).to have_button("Approve #{@pet_4.name}")
    expect(page).to have_button("Reject #{@pet_4.name}")

  end
end
