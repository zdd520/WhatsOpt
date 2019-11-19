# frozen_string_literal: true

require "test_helper"

class AnalysesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:user1)
    @mda = analyses(:cicav)
  end

  test "should get index" do
    get mdas_url
    assert_response :success
  end

  test "should get new" do
    get new_mda_url
    assert_response :success
  end

  test "should create analysis" do
    assert_difference("Analysis.count") do
      post mdas_url, params: {
        analysis: { name: "test" } }
    end
    assert_redirected_to edit_mda_url(Analysis.last)
  end

  test "should assign owner on creation" do
    post mdas_url, params: { analysis: { name: "test2" } }
    assert Analysis.last.owner, users(:user1)
  end

  test "should authorized access by default" do
    post mdas_url, params: { analysis: { name: "test2" } }
    sign_out users(:user1)
    sign_in users(:user2)
    get mda_url(Analysis.last)
    assert_response :success
    # assert_redirected_to root_path
  end

  test "should authorized access if public attr is set" do
    post mdas_url, params: { analysis: { name: "test2", public: true } }
    sign_out users(:user1)
    sign_in users(:user2)
    get mda_url(Analysis.last)
    assert_response :success
  end

  test "should authorized access to members" do
    sign_in users(:user3)
    get mda_url(@mda)
    assert_response :success
  end

  test "should import analysis from excel" do
    assert_difference("Analysis.count") do
      post mdas_url, params: {
        analysis: { attachment_attributes: { data: fixture_file_upload("excel_mda_dummy.xlsx") } } }
    end
    assert_redirected_to mda_url(Analysis.last)
  end

  test "should import analysis from cmdows" do
    assert_difference("Analysis.count") do
      post mdas_url, params: {
        analysis: { attachment_attributes: { data: fixture_file_upload("cmdows_mda_sample.cmdows") } } }
    end
    assert_redirected_to mda_url(Analysis.last)
  end

  test "should import glider analysis from excel and export cmdows" do
    assert_difference("Analysis.count") do
      post mdas_url, params: {
        analysis: { attachment_attributes: { data: fixture_file_upload("excel_glider.xlsx") } } }
    end
    assert_redirected_to mda_url(Analysis.last)
    get mda_exports_new_url(Analysis.last, format: "cmdows")
  end

  test "should show analysis" do
    get mda_url(@mda)
    assert_response :success
  end

  test "should get edit" do
    get edit_mda_url(@mda)
    assert_response :success
  end

  test "should update analysis" do
    patch mda_url(@mda), params: { analysis: { name: @mda.name } }
    assert_redirected_to mda_url(@mda)
  end

  test "should destroy analysis" do
    assert_difference("Analysis.count", -1) do
      delete mda_url(@mda)
    end

    assert_redirected_to mdas_url
  end

  test "should not destroy analysis, if not owner" do
    sign_out users(:user1)
    sign_in users(:user2)
    assert_difference("Analysis.count", 0) do
      delete mda_url(@mda)
    end
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:error]
  end

  test "should destroy discipline when destroying analysis" do
    q = @mda.disciplines
    assert_difference("Discipline.count", -q.count) do
      delete mda_url(@mda)
    end
  end

  test "should destroy variables when destroying analysis" do
    q = Variable.joins(discipline: :analysis).where(analyses: { id: @mda.id })
    assert_difference("Variable.count", -q.count) do
      delete mda_url(@mda)
    end
  end

  test "should destroy connections when destroying analysis" do
    q = Connection.of_analysis(@mda.id)
    assert_difference("Connection.count", -q.count) do
      delete mda_url(@mda)
    end
  end

  test "should not destroy sub-analysis when destroying parent" do
    @outermda = analyses(:outermda)
    assert_difference("Analysis.count", -1) do
      delete mda_url(@outermda)
    end
  end

  test "should make a copy of an analysis" do
    sign_out users(:user1)
    sign_in users(:user2)
    assert_difference("Analysis.count") do
      post mdas_url, params: { mda_id: @mda.id }
      assert_redirected_to mda_url(Analysis.last)
    end
  end

end
