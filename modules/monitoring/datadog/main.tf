# Install the Datadog Agent using the helm chart
resource "helm_release" "datadog_helm" {
  name       = "datadog"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  set {
    name  = "datadog.apiKey"
    value = var.api_key
  }

  set {
    name  = "datadog.tags"
    value = "{group:${var.group_id}, cluster:group-${var.group_id}}"
  }
}

# Install the Datadog dashboard.
terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

# Configure the Datadog provider
provider "datadog" {
  api_key = var.api_key
  app_key = var.app_key
}

# Get the "Bootcamps" dashboard list
data "datadog_dashboard_list" "bootcamps_list" {
  name = "Bootcamps"
}

# Create the dashboard.
resource "datadog_dashboard_json" "dashboard_json" {
  dashboard_lists = ["${data.datadog_dashboard_list.bootcamps_list.id}"]
  dashboard = <<EOF
{
  "title": "Group ${var.group_id} Dashboard",
  "description": "Automatically created using the terraform provider. Changes will be lost.",
  "widgets": [
    {
      "id": 424731658936064,
      "definition": {
        "type": "note",
        "content": "Additional information & resources:\n\n- [Kubernetes Dashboard](https://app.datadoghq.com/screen/integration/86/kubernetes---overview?tpl_var_scope=group%3A${var.group_id})\n- [Containers Dashboard](https://app.datadoghq.com/containers?tags=group%3A${var.group_id})\n- [Logs](https://app.datadoghq.com/logs?query=group%3A${var.group_id})\n- [Services architecture diagram](https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/docs/img/architecture-diagram.png)",
        "background_color": "white",
        "font_size": "18",
        "text_align": "left",
        "show_tick": false,
        "tick_pos": "50%",
        "tick_edge": "left"
      }
    },
    {
      "id": 3607026526613620,
      "definition": {
        "title": "Boutique Shop Traffic (Completed Web Requests)",
        "show_legend": false,
        "type": "timeseries",
        "requests": [
          {
            "q": "sum:shop.frontend.request_complete{group:${var.group_id}}.as_count().rollup(sum, 60)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "min": "auto",
          "max": "auto"
        },
        "events": [
          {
            "q": "gremlin.team:group_${var.group_id}"
          }
        ]
      }
    },
    {
      "id": 2937119681100386,
      "definition": {
        "title": "Successful Checkouts (Payment Complete)",
        "show_legend": false,
        "type": "timeseries",
        "requests": [
          {
            "q": "sum:shop.checkoutservice.payment_success{group:${var.group_id}}.as_count().rollup(sum, 60)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "min": "auto",
          "max": "auto"
        },
        "events": [
          {
            "q": "gremlin.team:group_${var.group_id}"
          }
        ]
      }
    },
    {
      "id": 2112548770689068,
      "definition": {
        "title": "System Metrics",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 6051520793167559,
            "definition": {
              "title": "Active Nodes",
              "type": "check_status",
              "check": "datadog.agent.up",
              "grouping": "cluster",
              "tags": [
                "group:${var.group_id}"
              ]
            }
          },
          {
            "id": 7245997605604425,
            "definition": {
              "title": "Nodes by CPU",
              "type": "hostmap",
              "requests": {
                "fill": {
                  "q": "max:system.cpu.system{group:${var.group_id}} by {host}"
                }
              },
              "no_metric_hosts": false,
              "no_group_hosts": true,
              "scope": [
                "group:${var.group_id}"
              ],
              "style": {
                "palette": "green_to_orange",
                "palette_flip": false,
                "fill_min": "3",
                "fill_max": "100"
              }
            }
          },
          {
            "id": 1856275834370859,
            "definition": {
              "title": "CPU Usage",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "avg:system.cpu.user{group:${var.group_id}} by {host}",
                  "style": {
                    "palette": "purple",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ],
              "markers": [
                {
                  "value": "y = 0",
                  "display_type": "error dashed"
                }
              ]
            }
          },
          {
            "id": 5283738802616544,
            "definition": {
              "title": "Free memory",
              "show_legend": false,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:system.mem.usable{group:${var.group_id}} by {host}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ],
              "markers": []
            }
          },
          {
            "id": 3716437845234839,
            "definition": {
              "title": "System IO",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "avg:system.io.util{group:${var.group_id}} by {host}",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ]
            }
          },
          {
            "id": 3865939773871699,
            "definition": {
              "title": "Pct Disk Used",
              "show_legend": false,
              "legend_layout": "auto",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "100 * (query1 / query2)"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:system.disk.used{group:${var.group_id}} by {host}"
                    },
                    {
                      "data_source": "metrics",
                      "name": "query2",
                      "query": "avg:system.disk.total{group:${var.group_id}} by {host}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "cool",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ],
              "markers": []
            }
          },
          {
            "id": 3109412137780157,
            "definition": {
              "title": "Network Bytes",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "avg:system.net.bytes_sent{group:${var.group_id}} by {host}",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                },
                {
                  "q": "avg:system.net.bytes_rcvd{group:${var.group_id}} by {host}",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ]
            }
          }
        ]
      }
    },
    {
      "id": 3575351769817847,
      "definition": {
        "title": "Service Metrics",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 8450226344557883,
            "definition": {
              "title": "TCP Response Time per Service",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "avg:network.tcp.response_time{group:${var.group_id}} by {url}",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "log",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ]
            }
          },
          {
            "id": 3051040020520518,
            "definition": {
              "title": "adservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:adservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 963069413297708,
            "definition": {
              "title": "cartservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:cartservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 3912433138602544,
            "definition": {
              "title": "checkoutservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:checkoutservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 876199403718878,
            "definition": {
              "title": "currencyservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:currencyservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 8945727563188280,
            "definition": {
              "title": "emailservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:emailservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 2558035315572097,
            "definition": {
              "title": "frontend Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:frontend}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 6860283099976008,
            "definition": {
              "title": "paymentservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:paymentservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 7183568897722437,
            "definition": {
              "title": "productcatalogservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:productcatalogservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 7294975627404891,
            "definition": {
              "title": "recommendationservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:recommendationservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          },
          {
            "id": 7462335384585672,
            "definition": {
              "title": "shippingservice Response Time",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1 * 1000"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "avg:network.tcp.response_time{group:${var.group_id},instance:shippingservice}",
                      "aggregator": "last"
                    }
                  ],
                  "response_format": "scalar",
                  "conditional_formats": [
                    {
                      "comparator": ">=",
                      "palette": "red_on_white",
                      "value": 500
                    },
                    {
                      "comparator": ">=",
                      "palette": "yellow_on_white",
                      "value": 250
                    },
                    {
                      "comparator": ">",
                      "palette": "green_on_white",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "ms",
              "text_align": "center",
              "precision": 1
            }
          }
        ]
      }
    },
    {
      "id": 5519685533509571,
      "definition": {
        "title": "Kubernetes Metrics",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 3730561971601356,
            "definition": {
              "title": "Pods Running",
              "time": {},
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "sum:kubernetes.pods.running{group:${var.group_id}}",
                      "aggregator": "avg"
                    }
                  ],
                  "response_format": "scalar"
                }
              ],
              "autoscale": true,
              "text_align": "center",
              "precision": 0
            }
          },
          {
            "id": 3526949109421286,
            "definition": {
              "title": "Container Restarts by Pod",
              "title_size": "16",
              "title_align": "left",
              "show_legend": false,
              "legend_layout": "vertical",
              "legend_columns": [
                "max",
                "value",
                "sum"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "Restarts",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "sum:kubernetes_state.container.restarts{group:${var.group_id}} by {pod_name}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "on_right_yaxis": false,
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "bars"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "label": "",
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "markers": []
            }
          },
          {
            "id": 2398687411132898,
            "definition": {
              "title": "Containers in CrashloopBackOff (by Pod)",
              "title_size": "16",
              "title_align": "left",
              "show_legend": false,
              "legend_layout": "vertical",
              "legend_columns": [
                "avg",
                "max",
                "value"
              ],
              "time": {},
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "CrashloopBackOff",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "sum:kubernetes.containers.state.waiting{reason:crashloopbackoff,group:${var.group_id}} by {pod_name}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "on_right_yaxis": false,
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "bars"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "label": "",
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "markers": []
            }
          },
          {
            "id": 4288511275320326,
            "definition": {
              "title": "CPU % Grouped by Microservices",
              "type": "hostmap",
              "requests": {
                "fill": {
                  "q": "avg:process.stat.container.cpu.total_pct{group:${var.group_id}} by {host}"
                }
              },
              "node_type": "container",
              "no_metric_hosts": false,
              "no_group_hosts": false,
              "group": [
                "kube_deployment"
              ],
              "scope": [
                "group:${var.group_id}"
              ],
              "style": {
                "palette": "YlOrRd",
                "palette_flip": false,
                "fill_min": "0",
                "fill_max": "100"
              }
            }
          },
          {
            "id": 6307380111819609,
            "definition": {
              "title": "Pods per Node",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(sum:kubernetes.pods.running{group:${var.group_id}} by {host}, 5, 'last', 'desc')"
                }
              ]
            }
          },
          {
            "id": 6040818210867049,
            "definition": {
              "title": "Kubernetes Pods/Containers per Node",
              "type": "hostmap",
              "requests": {
                "fill": {
                  "q": "avg:process.stat.container.cpu.total_pct{group:${var.group_id}} by {host}"
                }
              },
              "node_type": "container",
              "no_metric_hosts": true,
              "no_group_hosts": true,
              "group": [
                "host"
              ],
              "scope": [
                "group:${var.group_id}"
              ],
              "style": {
                "palette": "green_to_orange",
                "palette_flip": false
              }
            }
          },
          {
            "id": 42606791997821,
            "definition": {
              "title": "Most CPU-intensive pods",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(sum:kubernetes.cpu.usage.total{group:${var.group_id}} by {pod_name}, 100, 'mean', 'desc')"
                }
              ]
            }
          },
          {
            "id": 845416368619323,
            "definition": {
              "title": "Most memory-intensive pods",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(sum:kubernetes.memory.usage{group:${var.group_id}} by {pod_name}, 50, 'mean', 'desc')"
                }
              ]
            }
          }
        ]
      }
    },
    {
      "id": 8501274885629305,
      "definition": {
        "title": "Redis Metrics",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 411743120527384,
            "definition": {
              "title": "Blocked clients",
              "type": "query_value",
              "requests": [
                {
                  "q": "sum:redis.clients.blocked{group:${var.group_id}}",
                  "aggregator": "max",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 1
                    },
                    {
                      "hide_value": false,
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 1
                    }
                  ]
                }
              ],
              "autoscale": true,
              "text_align": "center",
              "precision": 0
            }
          },
          {
            "id": 3523164211902130,
            "definition": {
              "title": "Redis keyspace",
              "type": "query_value",
              "requests": [
                {
                  "q": "sum:redis.keys{group:${var.group_id}}",
                  "aggregator": "max",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": ">",
                      "palette": "white_on_green",
                      "value": 0
                    }
                  ]
                }
              ],
              "autoscale": true,
              "text_align": "left",
              "precision": 2
            }
          },
          {
            "id": 577968371488044,
            "definition": {
              "title": "Commands per second",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "sum:redis.net.commands{group:${var.group_id}}",
                  "style": {
                    "palette": "grey",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ]
            }
          },
          {
            "id": 1323102248338977,
            "definition": {
              "title": "Connected clients",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "sum:redis.net.clients{group:${var.group_id}}",
                  "style": {
                    "palette": "cool",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ]
            }
          },
          {
            "id": 649716800061467,
            "definition": {
              "title": "Cache hit rate",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "(avg:redis.stats.keyspace_hits{group:${var.group_id}}/(avg:redis.stats.keyspace_hits{group:${var.group_id}}+avg:redis.stats.keyspace_misses{group:${var.group_id}}))*100",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ]
            }
          },
          {
            "id": 3518832953866259,
            "definition": {
              "title": "Latency",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "avg:redis.info.latency_ms{group:${var.group_id}}",
                  "style": {
                    "palette": "orange",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "min": "auto",
                "max": "auto"
              },
              "events": [
                {
                  "q": "gremlin.team:group_${var.group_id}"
                }
              ]
            }
          },
          {
            "id": 5270906289664692,
            "definition": {
              "type": "note",
              "content": "For more Redis information, see the [Redis Dashboard](https://app.datadoghq.com/screen/integration/15/redis---overview?tpl_var_scope=group%3A${var.group_id})",
              "background_color": "white",
              "font_size": "18",
              "text_align": "left",
              "show_tick": false,
              "tick_pos": "50%",
              "tick_edge": "left"
            }
          }
        ]
      }
    }
  ],
  "template_variables": [],
  "layout_type": "ordered",
  "is_read_only": false,
  "notify_list": [],
  "reflow_type": "auto",
  "id": "j2g-suf-dwq"
}
  EOF
}
