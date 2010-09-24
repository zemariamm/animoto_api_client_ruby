require File.dirname(__FILE__) + '/../../spec_helper'

describe Animoto::Callbacks::Base do

  describe "loading from a response body" do
    describe "without errors" do
      before do
        @body = {
          'response' => {
            'payload' => {
              'base_callback' => {
                'state'  => 'completed',
                'links'   => {
                  'self'  => 'https://api.animoto.com/things/123'
                }
              }
            }
          }
        }
        @callback = Animoto::Callbacks::Base.new @body
      end
      
      it "should set the state" do
        @callback.state.should == 'completed'
      end
      
      it "should set the url" do
        @callback.url.should == 'https://api.animoto.com/things/123'
      end
      
      it "should set the errors to an empty array" do
        @callback.errors.should be_an_instance_of(Array)
        @callback.errors.should be_empty
      end
    end
    
    describe "with errors" do
      before do
        @body = {
          'response' => {
            'payload' => {
              'base_callback' => {
                'state'  => 'failed',
                'links'   => {
                  'self'  => 'https://api.animoto.com/things/123'
                }
              }
            },
            'status' => {
              'errors' => [
                {
                  'code' => 'COLLAPSING_HRUNG_DISASTER',
                  'message' => 'A hrung has chosen to collapse disastrously.'
                },
                {
                  'code' => 'TOTAL_EXISTENCE_FAILURE',
                  'message' => 'The server is suffering from Total Existence Failure.'
                }
              ]
            }
          }
        }
        @callback = Animoto::Callbacks::Base.new @body
      end
      
      it "should collect the errors into the errors array" do
        @callback.errors.size.should == 2
      end
      
      it "should cast the errors as Animoto::Error objects" do
        @callback.errors.all? { |e| Animoto::Error === e }.should be_true
      end      
    end
  end
  
end