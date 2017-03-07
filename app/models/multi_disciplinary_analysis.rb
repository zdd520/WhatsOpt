class MultiDisciplinaryAnalysis < ApplicationRecord
  has_many :disciplines

  def get_xdsm_json
    {
  "nodes": [
    {
      "type": "optimization", 
      "id": "Opt", 
      "name": "SLSQP"
    }, 
    {
      "type": "mda", 
      "id": "Dis1", 
      "name": "MDAGaussSeidel"
    }, 
    {
      "type": "analysis", 
      "id": "Dis2", 
      "name": "Propulsion"
    }, 
    {
      "type": "analysis", 
      "id": "Dis3", 
      "name": "Aerodynamics"
    }, 
    {
      "type": "analysis", 
      "id": "Dis4", 
      "name": "Mission"
    }, 
    {
      "type": "analysis", 
      "id": "Dis5", 
      "name": "Structure"
    }
  ], 
  "edges": [
    {
      "to": "Opt", 
      "from": "_U_", 
      "name": "x_1^(0), x_2^(0), x_3^(0), x_shared^(0)"
    }, 
    {
      "to": "_U_", 
      "from": "Opt", 
      "name": "y_4^*"
    }, 
    {
      "to": "Dis1", 
      "from": "Opt", 
      "name": "x_2, x_shared, x_3, x_1"
    }, 
    {
      "to": "Opt", 
      "from": "Dis1", 
      "name": "y_4"
    }, 
    {
      "to": "Dis2", 
      "from": "Opt", 
      "name": "x_shared, x_3"
    }, 
    {
      "to": "Dis3", 
      "from": "Opt", 
      "name": "x_2, x_shared"
    }, 
    {
      "to": "Dis4", 
      "from": "Opt", 
      "name": "x_shared"
    }, 
    {
      "to": "Opt", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis5", 
      "from": "Opt", 
      "name": "x_shared, x_1"
    }, 
    {
      "to": "_U_", 
      "from": "Dis2", 
      "name": "y_31^*, y_32^*, y_3^*, y_34^*, g_3^*"
    }, 
    {
      "to": "_U_", 
      "from": "Dis3", 
      "name": "y_21^*, y_24^*, y_23^*, y_2^*, g_2^*"
    }, 
    {
      "to": "Opt", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "_U_", 
      "from": "Dis5", 
      "name": "y_12^*, y_11^*, g_1^*, y_1^*, y_14^*"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis4", 
      "name": "y_4"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis1", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis1", 
      "name": "y_34, g_1, y_4, y_3, y_2, g_3, g_2, y_12, y_11, y_1, y_14, y_31, y_24, y_32, y_23, y_21"
    }, 
    {
      "to": "Dis2", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis2", 
      "name": "y_31, y_32, y_3, y_34, g_3"
    }, 
    {
      "to": "Dis3", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis3", 
      "name": "y_21, y_24, g_2, y_2, y_23"
    }, 
    {
      "to": "Dis4", 
      "from": "Dis5", 
      "name": "y_12, y_11, g_1, y_1, y_14"
    }, 
    {
      "to": "Dis5", 
      "from": "Dis4", 
      "name": "y_4"
    }
  ], 
  "workflow": []
    }
  end

end
