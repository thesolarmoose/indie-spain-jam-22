#if UNITY_2019_1_OR_NEWER
using UnityEditor;
using UnityAtoms.Editor;

namespace UnityAtoms.BaseAtoms.Editor
{
    /// <summary>
    /// Value List property drawer of type `NarrativeEvents.Data.Event`. Inherits from `AtomDrawer&lt;EventValueList&gt;`. Only availble in `UNITY_2019_1_OR_NEWER`.
    /// </summary>
    [CustomPropertyDrawer(typeof(EventValueList))]
    public class EventValueListDrawer : AtomDrawer<EventValueList> { }
}
#endif
