/* File : cola.i */
%module cola

/* Allow enum values to be logically ORed together as flags. */
%include "enumtypeunsafe.swg"

%{
#include <vector>
#include <libvpsc/rectangle.h>
#include <libvpsc/assertions.h>
#include <libcola/cola.h>
#include <libcola/cluster.h>
#include <libcola/convex_hull.h>
#include <libcola/compound_constraints.h>
#include <libcola/exceptions.h>
#include <libtopology/topology_graph.h>
#include <libavoid/libavoid.h>
/* Includes the header in the wrapper code */

using namespace Avoid;
using namespace cola;
using namespace hull;
using namespace vpsc;
using namespace topology;

%}

%ignore Avoid::XDIM;
%ignore Avoid::YDIM;
%ignore Avoid::Point::operator[];
%ignore cola::PreIteration::operator();
//%ignore cola::TestConvergence::operator();
%ignore operator<<(std::ostream &os, vpsc::Rectangle const &r);
%ignore vpsc::Rectangle::setXBorder(double);
%ignore vpsc::Rectangle::setYBorder(double);
%ignore vpsc::assertNoOverlaps(const Rectangles& rs);
%ignore Avoid::Point::operator==(const Point&) const;
%ignore Avoid::Point::operator!=(const Point&) const;
%ignore Avoid::Point::operator<(const Point&) const;
%ignore Avoid::Point::operator-(const Point&) const;
%ignore Avoid::Point::operator+(const Point&) const;
%ignore Avoid::ShapeConnectionPin::operator<(const ShapeConnectionPin& rhs) const;
%ignore Avoid::ShapeConnectionPin::operator==(const ShapeConnectionPin& rhs) const;
%ignore Avoid::CmpConnPinPtr::operator()(const ShapeConnectionPin *lhs, const ShapeConnectionPin *rhs) const;
%ignore cola::SubConstraint;
%ignore cola::SubConstraintAlternatives;
%ignore cola::SubConstraintInfo;
%ignore std::vector<cola::SubConstraintInfo>;
%ignore cola::NonOverlapConstraints;
%ignore cola::Resize::Resize();
%ignore vpsc::Constraint::Constraint();
%ignore topology::Segment;
%ignore topology::EdgePoint::inSegment;
%ignore topology::EdgePoint::outSegment;
%ignore topology::EdgePoint::bendConstraint;
%ignore topology::EdgePoint::prune();
%ignore topology::EdgePoint::getBendConstraint(std::vector<TopologyConstraint*>* ts);
%ignore topology::EdgePoint::createBendConstraint();
%ignore topology::EdgePoint::deleteBendConstraint();
%ignore topology::Edge::firstSegment;
%ignore topology::Edge::lastSegment;
%ignore topology::Edge::getTopologyConstraints(std::vector<TopologyConstraint*>* ts) const;
%ignore topology::Edge::getRoute() const;
%ignore topology::Edge::toString() const;
%ignore topology::Edge::toString() const;
%ignore topology::assertConvexBends(const Edges&);
%ignore topology::assertNoSegmentRectIntersection(const Nodes&, const Edges&);
%ignore topology::assertNoZeroLengthEdgeSegments(const Edges& es);
%ignore topology::compute_stress(const Edges&);
%ignore topology::printEdges(const Edges&);

%include "std_string.i"
%include "std_vector.i"
%include "std_pair.i"

/* Wrap every C++ action in try/catch statement so we convert all 
 * possible C++ exceptions (generated from C++ assertion failures)
 * into Java exceptions.
 */
%exception {
    try {
        $action
    } catch(vpsc::CriticalFailure cf) {
        jclass excep = jenv->FindClass("org/dunnart/adaptagrams/ColaException");
        if (excep)
            jenv->ThrowNew(excep, cf.what().c_str());
    } catch(cola::InvalidVariableIndexException ivi) {
        jclass excep = jenv->FindClass("org/dunnart/adaptagrams/ColaException");
        if (excep)
            jenv->ThrowNew(excep, ivi.what().c_str());
    } 
}

/* No longer needed, since we wrap everything.
 *
%javaexception("colajava.ColaException") cola::ConstrainedFDLayout::run {
    try {
        $action
    } catch(vpsc::CriticalFailure cf) {
        jclass excep = jenv->FindClass("colajava/ColaException");
        if (excep)
            jenv->ThrowNew(excep, cf.what().c_str());
    } catch(cola::InvalidVariableIndexException ivi) {
        jclass excep = jenv->FindClass("colajava/ColaException");
        if (excep)
            jenv->ThrowNew(excep, ivi.what().c_str());
    } 
}

%javaexception("colajava.ColaException") Avoid::Router::processTransaction() {
    try {
        $action
    } catch(vpsc::CriticalFailure cf) {
        jclass excep = jenv->FindClass("colajava/ColaException");
        if (excep)
            jenv->ThrowNew(excep, cf.what().c_str());
    } catch(cola::InvalidVariableIndexException ivi) {
        jclass excep = jenv->FindClass("colajava/ColaException");
        if (excep)
            jenv->ThrowNew(excep, ivi.what().c_str());
    } 
}
*/


/* Define a Java ColaException class.
 */
%typemap(javabase) cola::ColaException "java.lang.Exception";
%inline %{
namespace cola {
class ColaException {
    public:
        ColaException(const std::string& msg) : message(msg) {}
        std::string getMessage() {
            return message;
        }
    private:
      std::string message;
};
}
%}

/* We have a problem where Java objects that appear to no longer be used and
 * go out of scope will sometimes cause their internal C++ instances to be
 * freed prematurely.  For this reason we generate empty finialise methods 
 * for the following classes and clean them up later.  For libavoid, the 
 * Router instance takes ownership of these objects and deletes them when it
 * is freed.  For the cola/vpsc classes, a Java user can call 
 * ConstraintedFDLayout::freeAssociatedObjects() to free this memory.
 */
%typemap(javafinalize)
        vpsc::Rectangle,
        cola::CompoundConstraint,
        cola::AlignmentConstraint,
        cola::BoundaryConstraint,
        cola::DistributionConstraint,
        cola::MultiSeparationConstraint,
        cola::PageBoundaryConstraints,
        cola::SeparationConstraint,
        cola::Cluster,
        cola::RootCluster,
        cola::ConvexCluster,
        cola::RectangularCluster,
        Avoid::ShapeRef,
        Avoid::ConnRef,
        Avoid::ClusterRef,
        Avoid::JunctionRef,
		Avoid::Obstacle,
        Avoid::ShapeConnectionPin
        %{%}

%template(UnsatisfiableConstraintInfoVector) std::vector<cola::UnsatisfiableConstraintInfo *>;
%template(EdgeVector) std::vector<cola::Edge>;
%template(CharVector) std::vector<char>;
%template(ColaEdge) std::pair<unsigned,unsigned>;
%template(RectPtrVector) std::vector<vpsc::Rectangle*>;
%template(CompoundConstraintsVector) std::vector<cola::CompoundConstraint*>;
%template(ColaLocks) std::vector<cola::Lock>;
%template(ColaResizes) std::vector<cola::Resize>;
%template(ColaDesiredPositions) std::vector<cola::DesiredPosition>;
%template(TopologyEdgePointPtrVector) std::vector<topology::EdgePoint*>;
%template(TopologyEdgePointConstPtrVector) std::vector<const topology::EdgePoint*>;
%template(TopologyEdgePtrVector) std::vector<topology::Edge*>;
%template(TopologyNodePtrVector) std::vector<topology::Node*>;
%template(UnsignedVector) std::vector<unsigned>;
%template(ClusterVector) std::vector<cola::Cluster*>;
%template(PointVector) std::vector<Avoid::Point>;

%inline %{
void doubleArraySet(double *a, int i, double val) {
   a[i] = val;
}
double doubleArrayGet(const double *a, int i) {
   return a[i];
}
double *newDoubleArray(int size) {
   return new double[size];
}
void deleteDoubleArray(double* a) {
   delete a;
}
%}

%rename(testoperator) cola::TestConvergence::operator();

%rename(Avoid_Edge) Avoid::Edge;
%rename(Avoid_Rectangle) Avoid::Rectangle;

%rename(getVarOrig) topology::Node::getVar() const;

//%rename straightener::Edge StraightenerEdge;


/* Parse the header file to generate wrappers */
%include "libvpsc/rectangle.h"
%include "libvpsc/assertions.h"
%include "libcola/compound_constraints.h"
%include "libcola/cola.h"
%include "libcola/cluster.h"
%include "libcola/convex_hull.h"
%include "libcola/exceptions.h"
%include "libtopology/topology_graph.h"

%include "libavoid/geometry.h"
%include "libavoid/geomtypes.h"
%include "libavoid/connend.h"
%include "libavoid/router.h"
%include "libavoid/connector.h"
%include "libavoid/obstacle.h"
%include "libavoid/shape.h"
%include "libavoid/junction.h"
%include "libavoid/viscluster.h"
%include "libavoid/connectionpin.h"


/*
%include "libavoid/libavoid.h"
%include "libavoid/debug.h"
%include "libavoid/graph.h"
%include "libavoid/region.h"
%include "libavoid/static.h"
%include "libavoid/timer.h"
%include "libavoid/visibility.h"
%include "libcola/cluster.h"
//%include "libcola/cola.h"
%include "libcola/cola_log.h"
%include "libcola/conjugate_gradient.h"
%include "libcola/connected_components.h"
%include "libcola/convex_hull.h"
%include "libcola/gradient_projection.h"
%include "libcola/max_acyclic_subgraph.h"
%include "libcola/output_svg.h"
%include "libcola/shortest_paths.h"
%include "libcola/sparse_matrix.h"
%include "libtopology/topology_constraints.h"
%include "libtopology/topology_graph.h"
%include "libtopology/topology_log.h"
%include "libtopology/util.h"
%include "libvpsc/block.h"
%include "libvpsc/blocks.h"
%include "libvpsc/cbuffer.h"
%include "libvpsc/constraint.h"
%include "libvpsc/csolve_VPSC.h"
%include "libvpsc/exceptions.h"
%include "libvpsc/isnan.h"
%include "libvpsc/linesegment.h"
%include "libvpsc/mosek_quad_solve.h"
//%include "libvpsc/rectangle.h"
%include "libvpsc/solve_VPSC.h"
%include "libvpsc/variable.h"
*/

