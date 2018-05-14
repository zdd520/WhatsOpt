# -*- coding: utf-8 -*-
"""
  con_sigma5.py generated by WhatsOpt. 
"""
from con_sigma5_base import ConSigma5Base

class ConSigma5(ConSigma5Base):
    """ An OpenMDAO component to encapsulate ConSigma5 discipline """

    def __init__(self, scalers):
    	super(ConSigma5, self).__init__()
        self.scalers=scalers
	
    def compute(self, inputs, outputs):
        """ ConSigma5 computation """
    
        outputs['con_sigma5'] = inputs['sigma'][4]*self.scalers['sigma'][4]-1.9  


	
# To declare partial derivatives computation ...
# 
#    def setup()
#        super(ConSigma5, self).setup()
#        declare_partials('*', '*')  
			
#    def compute_partials(self, inputs, partials):
#        """ Jacobian for ConSigma5 """
    
   		
#       	partials['con_sigma5', 'sigma'] = np.zeros((1, 5))        