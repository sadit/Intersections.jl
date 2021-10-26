# This file is part of Intersections.jl

export binarysearch, doublingsearch, doublingsearchrev, seqsearch, seqsearchrev

"""
	binarysearch(A, x, sp=1, ep=length(A))

Finds the insertion position of `x` in `A` in the range `sp:ep`
"""
function binarysearch(A, x, sp=1, ep=length(A))
	while sp < ep
		mid = div(sp + ep, 2)
		if x <= _get_key(A, mid)
			ep = mid
		else
			sp = mid + 1
		end
	end
	
	x <= _get_key(A, sp) ? sp : sp + 1
end

"""
	doublingsearch(A, x, sp=1, ep=length(A))

Finds the insertion position of `x` in `A`, starting at `sp`
"""
function doublingsearch(A, x, sp=1, ep=length(A))
	p = 0
    i = 1

    while sp+i <= ep && _get_key(A, sp+i) < x
		p = i
		i += i
    end

    binarysearch(A, x, sp + p, min(ep, sp+i))
end


"""
	doublingsearchrev(A, x, sp=1, ep=length(A))

Finds the insertion position of `x` in `A`, starting at the end
"""
function doublingsearchrev(A, x, sp=1, ep=length(A))
	x > _get_key(A, ep) && return ep + 1

	i = 1
	p = ep
    while p >= sp && x <= _get_key(A, p)
		ep = p
		p -= i
		i += i
    end

	binarysearch(A, x, max(p, sp), ep)
end

function seqsearchrev(A, x, sp=1, ep=length(A))
	pos = ep + 1
	while pos > sp && x <= _get_key(A, pos-1)
        pos -= 1
    end

	pos
end

function seqsearch(A, x, sp=1, ep=length(A))
	x > _get_key(A, ep) && return ep + 1
	while sp <= ep && _get_key(A, sp) < x
        sp += 1
    end

	sp > ep ? ep : sp
end