using RecipesBase
using ColorTypes
import PlotUtils: cgrad, palette, color_list
using LaTeXStrings

@userplot NozzlePlot

@recipe function f(h::NozzlePlot;fields=(),gas=DefaultPerfectGas)
  nfields = length(fields) + 1

  if nfields == 1
    length(h.args) == 1 || error("`nozzleplot` should be given one argument.  Got: $(typeof(h.args))")
    noz, = h.args
  else
    length(h.args) == 4 || error("`nozzleplot` should be given four arguments.  Got: $(typeof(h.args))")
    noz, pb, p0, T0 = h.args
    nozproc = NozzleProcess(noz,pb,p0,T0,gas=gas)
  end

  linecolor := 1
  if plotattributes[:plot_object].n > 0
    lc = plotattributes[:plot_object].series_list[end][:linecolor]
    idx = findall(x -> RGBA(x) == lc,color_list(palette(:default)))
    linecolor := idx[1] + 1
  end

  layout := (nfields,1)
  size := (500,200*nfields)
  xticks := (0:0,["Throat"])

  xline = [0,0]

  fields_lower = lowercase.(fields)

  subnum = 0
  if in("pressure",fields_lower)
    subnum += 1

    p = ustrip.(pressure(nozproc),u"kPa")
    pmax = maximum(p)+50
    @series begin
      subplot := subnum
      linestyle --> :dash
      linecolor := :black
      #label := ""
      xline, [0,pmax]
    end
    @series begin
      subplot := subnum
      ylims --> (0,pmax)
      xlims := (-Inf,Inf)
      yguide := "Pressure (KPa)"
      #legend := true
      #annotations := (positions(noz)[end],p[end],nozzle_quality(noz,pb,p0))
      positions(noz), p
    end
  end

  if in("temperature",fields_lower)
    subnum += 1

    T = ustrip.(temperature(nozproc),u"K")
    Tmax = maximum(T)+100.0
    @series begin
      subplot := subnum
      linestyle --> :dash
      linecolor := :black
      xline, [0,Tmax]
    end
    @series begin
      subplot := subnum

      ylims --> (0,Tmax)
      xlims := (-Inf,Inf)
      yguide := "Temperature (K)"
      positions(noz), T
    end
  end

  if in("density",fields_lower)
    subnum += 1

    ρ = ustrip.(density(nozproc))
    ρmax = maximum(ρ)+1.0
    @series begin
      subplot := subnum
      linestyle --> :dash
      linecolor := :black
      xline, [0,ρmax]
    end
    @series begin
      subplot := subnum

      ylims --> (0,ρmax)
      xlims := (-Inf,Inf)
      yguide := "Density (kg/m3)"
      positions(noz), ρ
    end
  end

  if in("machnumber",fields_lower) || in("mach",fields_lower)
    subnum += 1

    M = ustrip.(machnumber(nozproc))
    Mmax = maximum(M)+1.0
    @series begin
      subplot := subnum
      linestyle --> :dash
      linecolor := :black
      xline, [0,Mmax]
    end
    @series begin
      subplot := subnum
      linestyle --> :dash
      linecolor := :black
      positions(noz), ones(length(positions(noz)))
    end
    @series begin
      subplot := subnum

      ylims --> (0,Mmax)
      xlims := (-Inf,Inf)
      yguide := "Mach Number"
      positions(noz), M
    end
  end

  subnum += 1
  A = ustrip.(areas(noz),u"cm^2")
  Amax = maximum(A)+10
  @series begin
    subplot := subnum
    linestyle --> :dash
    linecolor := :black
    xline, [0,Amax]
  end
  #@series begin
     subplot := subnum

     ylims --> (0,Amax)
     xlims := (-Inf,Inf)

     yguide := "Area (sq cm)"
     positions(noz),A
  #end

end
