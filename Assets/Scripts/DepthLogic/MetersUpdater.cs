using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DepthLogic
{
    public class MetersUpdater : MonoBehaviour
    {
        [SerializeField] private Transform _target;
        [SerializeField] private FloatVariable _metersVariable;

        private void Update()
        {
            var depth = _target.position.y;
            depth = depth > 0 ? 0 : depth;
            depth = depth < -100 ? -100 : depth;
            _metersVariable.Value = Mathf.Abs(depth);
        }
    }
}