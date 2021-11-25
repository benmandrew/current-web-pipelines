type 'a inline =
  ([> Html_types.core_phrasing_without_interactive ] as 'a) Tyxml_html.elt

type 'a block = ([> Html_types.div_content ] as 'a) Tyxml_html.elt

module type Renderer = sig
  val extra_routes : Current_web.Resource.t Routes.route list

  module Output : sig
    type t

    val render_inline : t -> [> Html_types.div_content ] Tyxml_html.elt
  end

  module Node : sig
    type t

    val render_inline : t -> _ inline

    val map_status : t -> 'a State.job_result -> 'a State.job_result
  end

  module Stage : sig
    type t

    val id : t -> string

    val render_inline : t -> _ inline

    val render : t -> _ block
  end

  module Pipeline : sig
    type t

    val id : t -> string

    val render_inline : t -> _ inline

    val render : t -> _ block

    val creation_date : t -> float
  end

  val render_index : unit -> _ block
end

module Make (R : Renderer) : sig
  type t

  type pipeline_state =
    (R.Output.t, R.Node.t, R.Stage.t, R.Pipeline.t) State.pipeline

  val make : unit -> t

  val update_state : t -> pipeline_state Current.t -> unit Current.t

  val routes : t -> Current_web.Resource.t Routes.route list
end
